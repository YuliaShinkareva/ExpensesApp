//
//  CoreDataProvider.swift
//  Budget_SwiftUI
//
//  Created by yulias on 20/06/2024.
//

import Foundation
import CoreData

class CoreDataProvider {
    let persistentContainer: NSPersistentContainer
    
    var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    static var preview: CoreDataProvider = {
        let provider = CoreDataProvider(inMemory: true)
        let context = provider.context
        
        let travelling = Budget(context: context)
        travelling.title = "Asia"
        travelling.limit = 15000
        travelling.dateCreated = Date()
        
        let food = Budget(context: context)
        food.title = "Food"
        food.limit = 1500
        food.dateCreated = Date()
        
        let shopping = Budget(context: context)
        shopping.title = "Clothes"
        shopping.limit = 50
        shopping.dateCreated = Date()
        
        let skirt = Expenses(context: context)
        skirt.title = "Skirt"
        skirt.amount = 6.0
        skirt.dateCreated = Date()
        
        let dress = Expenses(context: context)
        dress.title = "Dress"
        dress.amount = 66.0
        dress.dateCreated = Date()
        
        let socks = Expenses(context: context)
        socks.title = "Socks"
        socks.amount = 3.5
        socks.dateCreated = Date()
        
        shopping.addToExpenses(skirt)
        shopping.addToExpenses(dress)
        shopping.addToExpenses(socks)
        
        // list of expenses
        let foodItems = ["Burger", "Cookies", "Popcorn", "Sushi", "Pizza", "Yogurt", "Coffee"]
        
        for foodItem in foodItems {
            let expense = Expenses(context: context)
            expense.title = foodItem
            expense.amount = Double.random(in: 8...300)
            expense.quantity = Int16(Int.random(in: 1...12))
            expense.dateCreated = Date()
            expense.budget = food
        }
        
        // insert tags
        let commonTags = ["Dining", "Education", "Food", "Fun", "Health", "Shopping", "Transportation", "Travel", "Utilities"]
        
        for commonTag in commonTags {
            let tag = Tag(context: context)
            tag.name = commonTag
            if let tagName = tag.name, ["Shopping"].contains(tagName) {
                skirt.addToTags(tag)
            }
        }
        
        do {
            try context.save()
        } catch {
            print(error)
        }
        
        return provider
    }()
    
    init(inMemory: Bool = false) {
        persistentContainer = NSPersistentContainer(name: "BudgetAppModel")
        
        if inMemory {
            persistentContainer.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        persistentContainer.loadPersistentStores { _, error in
            if let error {
                fatalError("Core Data store failed to initialize \(error)")
            }
        }
    }
}











