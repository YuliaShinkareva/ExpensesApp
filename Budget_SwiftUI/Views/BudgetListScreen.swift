//
//  BudgetListScreen.swift
//  Budget_SwiftUI
//
//  Created by yulias on 20/06/2024.
//

import SwiftUI

struct BudgetListScreen: View {
    
    @Environment(\.managedObjectContext) private var context
    @State private var isPresented: Bool = false
    @FetchRequest(sortDescriptors: []) private var budgets: FetchedResults<Budget>
    @State private var isFilterPresented: Bool = false
    
    private var total: Double {
        budgets.reduce(0) {limit, budget in
            budget.limit + limit
        }
    }
    
    private func deleteBudget(_ indexSet: IndexSet) {
        indexSet.forEach { index in
            let budget = budgets[index]
            context.delete(budget)
        }
        
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                if budgets.isEmpty {
                    ContentUnavailableView("No budgets available", systemImage: "pencil.and.scribble")
                } else {
                    List {
                        HStack {
                            Spacer()
                            Text("Total Limit")
                            Text(total, format: .currency(code: Locale.currencyCode))
                            Spacer()
                        }.font(.headline)
                        
                        ForEach(budgets) { budget in
                            NavigationLink {
                                BudgetDetailView(budget: budget)
                            } label: {
                                BudgetCellView(budget: budget)
                            }
                        }.onDelete(perform: deleteBudget)
                    }
                }
            }
            .overlay(alignment: .bottom, content: {
                Button("Filter") {
                    isFilterPresented = true
                }.buttonStyle(.borderedProminent)
                    .tint(.gray)
            })
            .navigationTitle("Budget")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Add Budget") {
                        isPresented = true
                    }
                }
            }
            .sheet(isPresented: $isPresented, content: {
                AddBudgetScreen()
            })
            .sheet(isPresented: $isFilterPresented, content: {
                NavigationStack {
                    FilterView()
                }
            })
        }
    }
}


#Preview {
    NavigationStack {
        BudgetListScreen()
    }.environment(\.managedObjectContext, CoreDataProvider.preview.context)
}

