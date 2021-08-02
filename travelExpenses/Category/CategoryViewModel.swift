//
//  CategoryViewModel.swift
//  report
//
//  Created by osa on 20.07.2021.
//

import Foundation

protocol CategoryViewModelProtocol {
    var categories: [String]  { get }
}

class CategoryViewModel: CategoryViewModelProtocol {
    var categories: [String] = DataManager.shared.categories

}
