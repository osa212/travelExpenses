//
//  OperationsViewModel.swift
//  report
//
//  Created by osa on 26.07.2021.
//

import Foundation

protocol OperationsCellViewModelProtocol {
    var sum: String { get }
    var sumExpense: String { get }
    var category: String { get }
    var date: String { get }
    
    init(income: Income?, expense: Expense?)
    
    func dateFormatToString(dateFormat: String, date: Date) -> String
}

class OperationsCellViewModel: OperationsCellViewModelProtocol {
    
    
    var date: String {
        if let income = income {
            let date = dateFormatToString(dateFormat: "dd/MM/yyyy",
                                          date: income.date)
            return date
        } else if let expense = expense {
            let date = dateFormatToString(dateFormat: "dd/MM/yyyy",
                                          date: expense.date)
            return date
        }
        return ""
    }
    
    var sum: String {
        if let income = income {
            return "\(income.amount.formatWithSeparator) ₽"
        }
        return ""
    }
    
    var sumExpense: String {
        if let expense = expense {
            return "\(expense.convertedAmount.formatWithSeparator) ₽"
        }
        return ""
    }
    
    var category: String {
        if let income = income {
            return income.category
        } else if let expense = expense {
            return expense.category
        }
        return ""
    }
    
    var income: Income?
    var expense: Expense?
    
    required init(income: Income?, expense: Expense?) {
        self.income = income
        self.expense = expense
    }
    
    func dateFormatToString(dateFormat: String, date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        return dateFormatter.string(from: date)
    }
}
