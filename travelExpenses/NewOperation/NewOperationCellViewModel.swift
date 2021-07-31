//
//  NewOperationCellViewModel.swift
//  report
//
//  Created by osa on 29.07.2021.
//

import Foundation

protocol NewOperationCellViewModelProtocol {
    var image: String { get }
    func getText() -> String

    init(indexPath: IndexPath)
}

protocol UserInputDelegate {
    func getAmount(amount: String)
}

class NewOperationCellViewModel: NewOperationCellViewModelProtocol, UserInputDelegate {
    var amount: String?
    
    func getAmount(amount: String) {
        self.amount = amount
    }
    
    let indexPath: IndexPath
    
    
    func getText() -> String {
        if let amount = amount {
            print("not nil", amount)
            return [amount, "Выбрать валюту", "Выбрать категорию", "Выбрать дату", "Сумма в рублях", "Добавить фото чека", "Способ оплаты", "Заметки"][indexPath.row]
            
        } else {
            return ["Ввести сумму", "Выбрать валюту", "Выбрать категорию", "Выбрать дату", "Сумма в рублях", "Добавить фото чека", "Способ оплаты", "Заметки"][indexPath.row]
            
        }
    }
    
    var image: String {
        DataManager.shared.operationImages[indexPath.row]
    }
    
    required init(indexPath: IndexPath) {
        self.indexPath = indexPath
    }
  
    
}
    

