//
//  Locale + Extensions.swift
//  Budget_SwiftUI
//
//  Created by yulias on 20/06/2024.
//

import Foundation

extension Locale {
    
    static var currencyCode: String {
        Locale.current.currency?.identifier ?? "USD"
    }
}
