//
//  ReceiptsViewModel.swift
//  report
//
//  Created by osa on 18.07.2021.
//

import Foundation
import RealmSwift

protocol ReceiptsViewModelProtocol {
    var title: String { get }
    var expenses: Results<Expense> { get }
    func cellViewModel(indexPath: IndexPath) -> ReceiptsViewCellModelProtocol
    func imageViewModel(indexPath: IndexPath) -> ImageViewModelProtocol
}

class ReceiptsViewModel: ReceiptsViewModelProtocol {
    
    var title: String {
        "Чеки"
    }
    
    var expenses: Results<Expense> = StorageManager.shared.realm.objects(Expense.self).filter("receipt != ''")
    
    func cellViewModel(indexPath: IndexPath) -> ReceiptsViewCellModelProtocol {
        let expense = expenses[indexPath.row]
        return ReceiptsViewCellModel(expense: expense)
    }
    
    func imageViewModel(indexPath: IndexPath) -> ImageViewModelProtocol {
        let expense = expenses[indexPath.row]
        return ImageViewModel(expense: expense)
    }
}
