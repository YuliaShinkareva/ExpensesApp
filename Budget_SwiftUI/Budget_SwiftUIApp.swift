//
//  Budget_SwiftUIApp.swift
//  Budget_SwiftUI
//
//  Created by yulias on 20/06/2024.
//

import SwiftUI

@main
struct Budget_SwiftUIApp: App {
    
    let provider: CoreDataProvider
    let tagSeeder: TagsSeeder
    
    init() {
        provider = CoreDataProvider()
        tagSeeder = TagsSeeder(context: provider.context)
    }
    
    var body: some Scene {
        WindowGroup {
            BudgetListScreen()
                .onAppear {
                    let hasSeededData = UserDefaults.standard.bool(forKey: "hasSeedData")
                    if !hasSeededData {
                        
                        let commonTags = ["Dining", "Education", "Food", "Fun", "Health", "Shopping", "Transportation", "Travel", "Utilities"]
                        do {
                            try tagSeeder.seed(commonTags)
                            UserDefaults.standard.setValue(true, forKey: "hasSeedData")
                        } catch {
                            print(error)
                        }
                    }
                }
                .environment(\.managedObjectContext, provider.context)
        }
    }
}
