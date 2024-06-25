//
//  Expenses + Extensions.swift
//  Budget_SwiftUI
//
//  Created by yulias on 25/06/2024.
//

import Foundation
import CoreData

extension Expenses {
    
    var total: Double {
        amount * Double(quantity)
    }
}
