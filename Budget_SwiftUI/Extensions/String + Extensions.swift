//
//  String + Extensions.swift
//  Budget_SwiftUI
//
//  Created by yulias on 20/06/2024.
//

import Foundation

extension String {
    
    var isEmptyOrWhiteSpace: Bool {
        trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}
