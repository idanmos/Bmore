//
//  GraphConfiguration.swift
//  B-more
//
//  Created by Idan Moshe on 11/01/2021.
//

import Foundation

struct GraphConfiguration {
    var title: String = ""
    var subtitle: String = ""
    var tooltip: String = Application.SpecialCharacters.localizedCurrencySign
    var categories: [String] = []
    var balance = FinancialBalance()
    var isRefresh: Bool = false
}
