//
//  ExpenseCellView.swift
//  Budget_SwiftUI
//
//  Created by yulias on 21/06/2024.
//

import SwiftUI

struct ExpenseCellView: View {
    
    @ObservedObject var expense: Expenses
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(expense.title ?? "")
                Text("(\(expense.quantity))")
                Spacer()
                Text(expense.total, format: .currency(code: Locale.currencyCode))
                    .allowsHitTesting(false)
            } 
            
            ScrollView(.horizontal) {
                HStack {
                    ForEach(Array(expense.tags as? Set<Tag> ?? [])) { tag in
                        Text(tag.name ?? "")
                            .font(.caption)
                            .padding(6)
                            .foregroundStyle(.white)
                            .background(.blue)
                            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                        
                    }
                }
            }
        }
    }
}

struct ExepnseCellViewContainer: View {
    @FetchRequest(sortDescriptors: []) private var expenses: FetchedResults<Expenses>
    
    var body: some View {
        ExpenseCellView(expense: expenses[0])
    }
}

#Preview {
    ExepnseCellViewContainer()
        .environment(\.managedObjectContext, CoreDataProvider.preview.context)
}

 
