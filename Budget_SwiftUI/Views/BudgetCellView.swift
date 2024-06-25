//
//  BudgetCellView.swift
//  Budget_SwiftUI
//
//  Created by yulias on 20/06/2024.
//

import SwiftUI

struct BudgetCellView: View {
    
    let budget: Budget
    
    var body: some View {
        HStack {
            Text(budget.title ?? "Budget will be displayed here...")
            Spacer()
            Text(budget.limit, format: .currency(code: Locale.currencyCode))
        }
    }
}

struct BudgetCellViewContainer: View {
    @FetchRequest(sortDescriptors: []) private var budgets: FetchedResults<Budget>
    
    var body: some View {
        BudgetCellView(budget: budgets[0])
    }
}

#Preview {
    BudgetCellViewContainer()
        .environment(\.managedObjectContext, CoreDataProvider.preview.context)
}

