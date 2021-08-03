//
//  NewOperationViewModel.swift
//  report
//
//  Created by osa on 27.07.2021.
//

import Foundation

protocol NewOperationViewModelProtocol {
    var trip: Trip? { get }
    var income: Income? { get }
    var expense: Expense? { get }
        
    var numberOfRowsExpenses: Int { get }
    var numberOfRowsIncomes: Int { get }
    
    var array: [String] { get set }
    
    init(income: Income)
    init(expense: Expense)
    init(trip: Trip)
    
    func dateFormatToString(dateFormat: String, date: Date) -> String
    func dateFormatToDate(dateFormat: String, dateString: String) -> Date?
    func dateStringToString(date: String) -> String
    
    func imageViewModel() -> ImageViewModelProtocol?
    func cellViewModel(indexPath: IndexPath) -> NewOperationCellViewModelProtocol?
    func receiptCellViewModel() -> ReceiptsViewCellModelProtocol?
    func currencyViewModel(date: String) -> CurrencyViewModelProtocol
    
    func saveExpense(amount: String, currency: String, category: String, date: String, convertedAmount: String, receipt: String, method: String, note: String)
    func saveIncome(amount: String, currency: String, category: String, date: String)
    
    func convert(currency: CurrencyName, amount: String) -> [String]
}


class NewOperationViewModel: NewOperationViewModelProtocol {
    
    var trip: Trip?
    var income: Income?
    var expense: Expense?
    
    var numberOfRowsExpenses: Int {
        DataManager.shared.expensesImages.count
    }
    
    var numberOfRowsIncomes: Int {
        DataManager.shared.incomesImages.count
    }
    
    var array = ["Выбрать дату", "Ввести сумму", "Выбрать валюту", "Выбрать категорию", "Сумма в рублях", "Добавить фото чека", "Способ оплаты"]
    
    
    required init(trip: Trip) {
        self.trip = trip
    }

    required init(income: Income) {
        self.income = income
    }
    
    required init(expense: Expense) {
        self.expense = expense
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
    func dateStringToString(date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyy"
        guard let dateData = dateFormatter.date(from: date) else { return ""}
        dateFormatter.dateFormat = "yyyy/MM/dd"
        return dateFormatter.string(from: dateData)
    }
    
    
    func imageViewModel() -> ImageViewModelProtocol? {
        if let expense = expense {
            return ImageViewModel(expense: expense)
        }
        return nil
    }
    func cellViewModel(indexPath: IndexPath) -> NewOperationCellViewModelProtocol? {
        return NewOperationCellViewModel(indexPath: indexPath)
    }
    
    func receiptCellViewModel() -> ReceiptsViewCellModelProtocol? {
        if let expense = expense {
            return ReceiptsViewCellModel(expense: expense)
        }
        return nil
    }
    
    func currencyViewModel(date: String) -> CurrencyViewModelProtocol {
        return CurrencyViewModel(choosenDate: date)
    }
    
    func saveExpense(amount: String, currency: String, category: String, date: String, convertedAmount: String, receipt: String, method: String, note: String) {
        guard let amountDouble = Double(amount) else { return }

        guard let dateFormat = dateFormatToDate(
                dateFormat: "dd/MM/yyyy",
                dateString: date) else { return }
        guard let convertedDouble = Double(convertedAmount) else { return }

        if let expense = expense {
            StorageManager.shared.editExpense(expense: expense,
                                              amount: amountDouble,
                                              currency: currency,
                                              category: category,
                                              date: dateFormat,
                                              convertedAmount: convertedDouble,
                                              receipt: receipt,
                                              method: method,
                                              note: note)
            
        } else {
            let newExpense = Expense(value: [amountDouble, currency, category, dateFormat, convertedDouble, receipt, method, note])
            guard let trip = trip else { return }
            StorageManager.shared.saveExpense(expense: newExpense, trip: trip)
        }
    }
    
    func saveIncome(amount: String, currency: String, category: String, date: String) {
        guard let amountDouble = Double(amount) else { return }
        
        guard let dateFormat = dateFormatToDate(dateFormat: "dd/MM/yyyy", dateString: date) else { return}
        
        if let income = income {
            StorageManager.shared.editIncome(income: income,
                                             amount: amountDouble,
                                             date: dateFormat,
                                             category: category,
                                             currency: currency)
        } else {
            let newIncome = Income(value: [amountDouble, currency, category, dateFormat])
            guard let trip = trip else { return }
            StorageManager.shared.saveIncome(income: newIncome, trip: trip)
        }
    }
   
    func convert(currency: CurrencyName, amount: String) -> [String] {
        guard let nominal = currency.Nominal else { return [""] }
        guard let value = currency.Value else { return [""]}
        guard let code = currency.CharCode else { return [""]}
        guard let amount = Double(amount) else { return [""]}
        
        let convertedAmount = amount / nominal * value
        let roundedAmount = String(format: "%.2f", convertedAmount)
        
        let convertedText = String(roundedAmount)
        let conversionLabelText = "Курс ЦБ \(value) RUB = \(nominal) \(code)"
        
        return [convertedText, conversionLabelText]
    }
}


