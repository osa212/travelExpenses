//
//  ReceiptsViewCellModel.swift
//  report
//
//  Created by osa on 18.07.2021.
//

import Foundation

protocol ReceiptsViewCellModelProtocol {
    var imageData: Data? { get }
    init(expense: Expense)
}

class ReceiptsViewCellModel: ReceiptsViewCellModelProtocol {
    
    private let expense: Expense
    
    required init(expense: Expense) {
        self.expense = expense
    }
    
    var imageData: Data? {
        let documentDirectory = FileManager.SearchPathDirectory.documentDirectory
        let userDomainMask = FileManager.SearchPathDomainMask.userDomainMask
        let path = NSSearchPathForDirectoriesInDomains(documentDirectory,
                                                       userDomainMask,
                                                       true)
        if let directoryPath = path.first {
            let imageUrl = URL(fileURLWithPath: directoryPath).appendingPathComponent(expense.receipt)
            let imageData = try? Data(contentsOf: imageUrl)
            return imageData
        }
        return nil
    }
}
