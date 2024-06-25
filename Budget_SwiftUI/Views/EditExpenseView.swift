//
//  EditExpenseView.swift
//  Budget_SwiftUI
//
//  Created by yulias on 25/06/2024.
//

import SwiftUI

struct EditExpenseView: View {
    
    @Environment(\.managedObjectContext) private var context
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var expense: Expenses
    
    private func updateExpense() {
        do {
            try context.save()
            dismiss()
        } catch {
            print(error)
        }
    }
    
    var body: some View {
        Form {
            TextField("Title", text: Binding(get: {
                expense.title ?? ""
            }, set: { newValue in
                expense.title = newValue
            }))
            TextField("Amount", value: $expense.amount, format: .number)
            TextField("Quantity", value: $expense.quantity, format: .number)
            TagsView(selectedTags: Binding(get: {
                Set(expense.tags?.compactMap { $0 as? Tag } ?? [] )
            }, set: { newValue in
                expense.tags = NSSet(array: Array(newValue))
            }))
        }
        .toolbar(content: {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Update") {
                    updateExpense()
                }
            }
        })
        .navigationTitle(expense.title ?? "")
    }
}

struct EditExpenseViewContainer: View {
    @FetchRequest(sortDescriptors: []) private var expenses: FetchedResults<Expenses>
    
    var body: some View {
        NavigationStack {
            EditExpenseView(expense: expenses[0])
        }
    }
}

#Preview {
    EditExpenseViewContainer()
        .environment(\.managedObjectContext, CoreDataProvider.preview.context)
}
