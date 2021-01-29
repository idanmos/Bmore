//
//  BalanceViewModel.swift
//  B-more
//
//  Created by Idan Moshe on 02/01/2021.
//

import UIKit

enum BalanceType: Int, CaseIterable {
    case day, week, month, quarter, year
    
    func title() -> String {
        switch self {
        case .day: return NSLocalizedString("day", comment: "")
        case .week: return NSLocalizedString("week", comment: "")
        case .month: return NSLocalizedString("week", comment: "")
        case .quarter: return NSLocalizedString("quarter", comment: "")
        case .year: return NSLocalizedString("year", comment: "")
        }
    }
    
    func subtitle(date: Date) -> String {
        switch self {
        case .day: return DateFormatter.dayFormatter.string(from: date)
        case .week:
            let startOfWeek: String = DateFormatter.dayFormatter.string(from: date.startOfWeek())
            let endOfWeek: String = DateFormatter.dayFormatter.string(from: date.endOfWeek())
            return "\(startOfWeek) - \(endOfWeek)"
        case .month: return DateFormatter.monthFormatter.string(from: date)
        case .quarter: return DateFormatter.quarterFormatter.string(from: date)
        case .year: return DateFormatter.yearFormatter.string(from: date)
        }
    }
}

class BalanceViewModel {
    
    private var dayBalance = FinancialBalance()
    private var weekBalance = FinancialBalance()
    private var monthBalance = FinancialBalance()
    private var quarterBalance = FinancialBalance()
    private var yearBalance = FinancialBalance()
        
    private var date: Date!
    
    var presenter: UIViewController?
    
    init() {
        self.load(date: Date())
    }
    
    func getDisplayDate() -> Date {
        return self.date
    }
    
    func load(date: Date) {
        self.date = date
        self.loadBalance()
    }
    
    private func loadBalance() {
        self.dayBalance = FinancialBalance()
        self.weekBalance = FinancialBalance()
        self.monthBalance = FinancialBalance()
        self.quarterBalance = FinancialBalance()
        self.yearBalance = FinancialBalance()
        
        let transactions: [Transaction] = TransactionsViewModel.fetchTransactions().sorted { (lhs: Transaction, rhs: Transaction) -> Bool in
            let firstDate: Date = lhs.date ?? Date.distantPast
            let secondDate: Date = rhs.date ?? Date.distantPast
            return firstDate < secondDate
        }
        
        for transaction: Transaction in transactions {
            if let transactionDate: Date = transaction.date,
               let price: NSDecimalNumber = transaction.price {
                /// - Tag: Day
                if transactionDate.isInSameDay(as: self.date) {
                    if let type = Application.TransactionType(rawValue: transaction.type) {
                        switch type {
                        case .none:
                            self.dayBalance.none += price.doubleValue
                        case .expense:
                            self.dayBalance.expenses += price.doubleValue
                        case .revenue:
                            self.dayBalance.revenue += price.doubleValue
                        }
                    }
                }
                
                /// - Tag: Week
                if transactionDate.isInSameWeek(as: self.date) {
                    if let type = Application.TransactionType(rawValue: transaction.type) {
                        switch type {
                        case .none:
                            self.weekBalance.none += price.doubleValue
                        case .expense:
                            self.weekBalance.expenses += price.doubleValue
                        case .revenue:
                            self.weekBalance.revenue += price.doubleValue
                        }
                    }
                }
                
                /// - Tag: Month
                if transactionDate.isInSameMonth(as: self.date) {
                    if let type = Application.TransactionType(rawValue: transaction.type) {
                        switch type {
                        case .none:
                            self.monthBalance.none += price.doubleValue
                        case .expense:
                            self.monthBalance.expenses += price.doubleValue
                        case .revenue:
                            self.monthBalance.revenue += price.doubleValue
                        }
                    }
                }
                
                /// - Tag: Quarter
                let quarter1 = DateFormatter.shortQuarterFormatter.string(from: transactionDate)
                let quarter2 = DateFormatter.shortQuarterFormatter.string(from: self.date)
                debugPrint(quarter1, quarter2)
                if quarter1 == quarter2 {
                    if let type = Application.TransactionType(rawValue: transaction.type) {
                        switch type {
                        case .none:
                            self.quarterBalance.none += price.doubleValue
                        case .expense:
                            self.quarterBalance.expenses += price.doubleValue
                        case .revenue:
                            self.quarterBalance.revenue += price.doubleValue
                        }
                    }
                }
                
                /// - Tag: Year
                if transactionDate.isInSameYear(as: self.date) {
                    if let type = Application.TransactionType(rawValue: transaction.type) {
                        switch type {
                        case .none:
                            self.yearBalance.none += price.doubleValue
                        case .expense:
                            self.yearBalance.expenses += price.doubleValue
                        case .revenue:
                            self.yearBalance.revenue += price.doubleValue
                        }
                    }
                }
            }
        }
    }
    
    func getConfiguration(for balanceType: BalanceType) -> GraphConfiguration {
        switch balanceType {
        case .day:
            return GraphConfiguration(title: NSLocalizedString("day", comment: ""),
                                      subtitle: balanceType.subtitle(date: self.date),
                                      tooltip: Application.SpecialCharacters.localizedCurrencySign,
                                      categories: [],
                                      balance: self.dayBalance)
        case .week:
            return GraphConfiguration(title: NSLocalizedString("week", comment: ""),
                                      subtitle: balanceType.subtitle(date: self.date),
                                      tooltip: Application.SpecialCharacters.localizedCurrencySign,
                                      categories: [],
                                      balance: self.weekBalance)
        case .month:
            return GraphConfiguration(title: NSLocalizedString("month", comment: ""),
                                      subtitle: balanceType.subtitle(date: self.date),
                                      tooltip: Application.SpecialCharacters.localizedCurrencySign,
                                      categories: [],
                                      balance: self.monthBalance)
        case .quarter:
            return GraphConfiguration(title: NSLocalizedString("quarter", comment: ""),
                                      subtitle: balanceType.subtitle(date: self.date),
                                      tooltip: Application.SpecialCharacters.localizedCurrencySign,
                                      categories: [],
                                      balance: self.quarterBalance)
        case .year:
            return GraphConfiguration(title: NSLocalizedString("year", comment: ""),
                                      subtitle: balanceType.subtitle(date: self.date),
                                      tooltip: Application.SpecialCharacters.localizedCurrencySign,
                                      categories: [],
                                      balance: self.yearBalance)
        }
    }
        
}
