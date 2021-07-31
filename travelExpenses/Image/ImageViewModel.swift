//
//  ImageViewModel.swift
//  report
//
//  Created by osa on 18.07.2021.
//

import Foundation

protocol ImageViewModelProtocol {
    var receipt: String { get }
    init(expense: Expense)
}

class ImageViewModel: ImageViewModelProtocol {
    
    var receipt: String {
        expense.receipt
    }
    
    var expense: Expense
    
    required init(expense: Expense) {
        self.expense = expense
    }
}
