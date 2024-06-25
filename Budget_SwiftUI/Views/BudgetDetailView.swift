//
//  BudgetDetailView.swift
//  Budget_SwiftUI
//
//  Created by yulias on 20/06/2024.
//

import SwiftUI

struct BudgetDetailView: View {
    
    @Environment(\.managedObjectContext) private var context
    let budget: Budget
    @State private var title: String = ""
    @State private var amount: Double?
    @State private var quantity: Int?
    @State private var expenseToEdit: Expenses?
    @State private var selectedTags: Set<Tag> = []
    
    @FetchRequest(sortDescriptors: []) private var expenses: FetchedResults<Expenses>
    
    init(budget: Budget) {
        self.budget = budget
        _expenses = FetchRequest(sortDescriptors: [], predicate: NSPredicate(format: "budget == %@", budget))
    }
    
    private var isFormValid: Bool {
        !title.isEmptyOrWhiteSpace && amount != nil
        && Double(amount!) > 0
        && !selectedTags.isEmpty
        && quantity != nil
        && Int(quantity!) > 0
    }
    
    private func addExpense() {
        let expense = Expenses(context: context)
        expense.title = title
        expense.amount = amount ?? 0
        expense.quantity = Int16(quantity ?? 0)
        expense.dateCreated = Date()
        expense.tags = NSSet(array: Array(selectedTags))
        
        budget.addToExpenses(expense)
        
        do {
            try context.save()
            title = ""
            amount = nil
            quantity = nil
            selectedTags = []
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func deleteExpense(_ indexSet: IndexSet) {
        indexSet.forEach { index in
            let expense = expenses[index]
            context.delete(expense)
        }
        
        do {
            try context.save()
        } catch {
            context.rollback()
            print(error.localizedDescription)
        }
    }
    
    var body: some View {
        VStack {
            HStack {
                Text("Total budget: ")
                Text(budget.limit, format: .currency(code: Locale.currencyCode))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            
        }
        
        Form {
            Section("New expense") {
                TextField("Title", text: $title)
                TextField("Amount", value: $amount, format: .number)
                    .keyboardType(.numberPad)
                TextField("Quantity", value: $quantity, format: .number)
                
                TagsView(selectedTags: $selectedTags)
                
                Button(action: {
                    addExpense()
                }, label: {
                    Text("Save")
                        .frame(maxWidth: .infinity)
                }).buttonStyle(.borderedProminent)
                    .disabled(!isFormValid)
            }
            
            Section("Expenses") {
                List {
                    VStack(alignment: .leading) {
                        HStack {
                            Spacer()
                            Text("Total:")
                            Text(budget.spent, format: .currency(code: Locale.currencyCode))
                                .fontWeight(.bold)
                            Spacer()
                        }
                        
                        HStack {
                            Spacer()
                            Text("Remaining:")
                            Text(budget.remainig, format: .currency(code: Locale.currencyCode))
                                .foregroundStyle(budget.remainig < 0 ? .red : .green)
                                .fontWeight(.semibold)
                            Spacer()
                        }
                    }
                    
                    ForEach(expenses) { expense in
                        ExpenseCellView(expense: expense)
                            .onLongPressGesture {
                                expenseToEdit = expense
                            }
                    }.onDelete(perform: deleteExpense)
                }
            }
            
        }.navigationTitle(budget.title ?? "")
            .sheet(item: $expenseToEdit) { expenseToEdit in
                NavigationStack {
                    EditExpenseView(expense: expenseToEdit)
                }
            }
    }
}


struct BudgetDetailViewContainer: View {
    @FetchRequest(sortDescriptors: []) private var budgets: FetchedResults<Budget>
    
    var body: some View {
        BudgetDetailView(budget: budgets.first(where: {$0.title == "Clothes"})!)
    }
}

#Preview {
    NavigationStack {
        BudgetDetailViewContainer()
            .environment(\.managedObjectContext, CoreDataProvider.preview.context)
    }
}

