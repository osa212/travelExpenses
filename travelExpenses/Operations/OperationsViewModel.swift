//
//  OperationsViewModel.swift
//  report
//
//  Created by osa on 23.07.2021.
//

import Foundation
import RealmSwift

protocol OperationsViewModelProtocol {
    var trip: Trip { get }
    init(trip: Trip)
    
    var expenses: Results<Expense> { get }
    var incomes: Results<Income> { get }
    
    var incomeLabelText: String { get }
    var expenseLabelText: String { get }
    var balanceLabelText: String { get }
    
    func dateFormatToString(dateFormat: String, date: Date) -> String
    func dateFormatToDate(dateFormat: String, dateString: String) -> Date?
    
    func deleteTransaction(indexPath: IndexPath, segmentIndex: Int)
    

    func NewOperationViewModelIncome(indexPath: IndexPath) -> NewOperationViewModelProtocol
    func NewOperationViewModelExpense(indexPath: IndexPath) -> NewOperationViewModelProtocol
    func NewOperationViewModelNew(trip: Trip) -> NewOperationViewModelProtocol
    
    func OperationsCellViewModelIncome(indexPath: IndexPath) -> OperationsCellViewModelProtocol
    func OperationsCellViewModelExpense(indexPath: IndexPath) -> OperationsCellViewModelProtocol
    
    func saveIncome(_ index: Int) -> Income?
    func saveExpense(_ index: Int) -> Expense?
    
    func exportCSV() -> URL?
}

class OperationsViewModel: OperationsViewModelProtocol {
    let sort = UserDefaultsManager.shared.fetchSort()
    
    var trip: Trip
    
    var expenses: Results<Expense> {
        trip.expenses.sorted(byKeyPath: sort.sortExpenseBy,
                             ascending: sort.sortDirection)
    }
    
    var incomes: Results<Income> {
        trip.incomes.sorted(byKeyPath: sort.sortIncomeBy,
                            ascending: sort.sortDirection)
    }
    required init(trip: Trip) {
        self.trip = trip
    }
    
    var balanceLabelText: String {
        let incomeAmounts: [Double] = incomes.map { return $0.amount }
        let expenseAmounts: [Double] = expenses.map { return $0.convertedAmount }
        let balance = incomeAmounts.reduce(0, +) - expenseAmounts.reduce(0, +)
        return "\(balance.formatWithSeparator) руб."
    }
    
    var expenseLabelText: String {
        let expenseAmounts: [Double] = expenses.map { return $0.convertedAmount }
        let sumExpenses = expenseAmounts.reduce(0, +)
        return "\(sumExpenses.formatWithSeparator) руб."
    }
    
    var incomeLabelText: String {
        let incomeAmounts: [Double] = incomes.map { return $0.amount }
        let sumIncomes = incomeAmounts.reduce(0, +)
        return "\(sumIncomes.formatWithSeparator) руб."
    }
    
    func dateFormatToString(dateFormat: String, date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        return dateFormatter.string(from: date)
    }

    func dateFormatToDate(dateFormat: String, dateString: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        return dateFormatter.date(from: dateString)
    }
    
    func deleteTransaction(indexPath: IndexPath, segmentIndex: Int) {
        if segmentIndex == 0 {
            StorageManager.shared.deleteIncome(income: incomes[indexPath.row])
        } else if segmentIndex == 1 {
            StorageManager.shared.deleteExpense(expense: expenses[indexPath.row])
        }
    }
    

    func NewOperationViewModelNew(trip: Trip) -> NewOperationViewModelProtocol {
        return NewOperationViewModel(trip: trip)
    }
    func NewOperationViewModelIncome(indexPath: IndexPath) -> NewOperationViewModelProtocol {
        return NewOperationViewModel(income: incomes[indexPath.row])
    }
    func NewOperationViewModelExpense(indexPath: IndexPath) -> NewOperationViewModelProtocol {
        return NewOperationViewModel(expense: expenses[indexPath.row])
    }
    
    func saveIncome(_ index: Int) -> Income? {
        if index < incomes.count {
            return incomes[index]
        } else {
            return nil
        }
    }
    func saveExpense(_ index: Int) -> Expense? {
        if index < expenses.count {
            return expenses[index]
        } else {
            return nil
        }
    }
    
    func exportCSV() -> URL? {
        let fileName = "\(trip.city).csv"
        let path = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(fileName)
        var csvHead = "№,Date,Category,Incomes,Expenses\n"
        var number = 0
        
        for income in incomes {
            number += 1
            let date = dateFormatToString(dateFormat: "dd/MM/yyyy", date: income.date)
            csvHead.append("\(number),\(date),\(income.category),\(income.amount)\n")
        }
        for expense in expenses {
            number += 1
            let date = dateFormatToString(dateFormat: "dd/MM/yyyy", date: expense.date)
            csvHead.append("\(number),\(date),\(expense.category), ,-\(expense.convertedAmount)\n")
        }
        
        let incomeAmounts: [Double] = incomes.map { return $0.amount }
        let sumIncomes = String(incomeAmounts.reduce(0, +))
        
        let expenseAmounts: [Double] = expenses.map { return $0.convertedAmount }
        let sumExpenses = String(expenseAmounts.reduce(0, +))
        let balance = String(incomeAmounts.reduce(0, +) - expenseAmounts.reduce(0, +))
        
        csvHead.append(" , , , \(sumIncomes), \(sumExpenses)\n")
        csvHead.append(" , , , Balance, \(balance)\n")
        
        
        do {
            try csvHead.write(to: path!, atomically: true, encoding: .utf8)
        }
         catch let error {
            print(error)
        }
        return path
    }
    
    func OperationsCellViewModelIncome(indexPath: IndexPath) -> OperationsCellViewModelProtocol {
        return OperationsCellViewModel(income: incomes[indexPath.row], expense: nil)
    }
    func OperationsCellViewModelExpense(indexPath: IndexPath) -> OperationsCellViewModelProtocol {
        return OperationsCellViewModel(income: nil, expense: expenses[indexPath.row])
    }
}
