//
//  NewOperationCellViewModel.swift
//  report
//
//  Created by osa on 29.07.2021.
//

import Foundation

protocol NewOperationCellViewModelProtocol {
    var image: String { get }

    init(indexPath: IndexPath)
    
}


class NewOperationCellViewModel: NewOperationCellViewModelProtocol {
    
    let indexPath: IndexPath
    
    required init(indexPath: IndexPath) {
        self.indexPath = indexPath
    }
    
    var image: String {
        DataManager.shared.expensesImages[indexPath.row]
    }
    
    
  
    
}
