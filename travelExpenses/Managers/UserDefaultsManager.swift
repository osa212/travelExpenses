//
//  UserDefaults.swift
//  travelExpenses
//
//  Created by osa on 04.08.2021.
//

import Foundation

class UserDefaultsManager {
    static let shared = UserDefaultsManager()
    
    let userDefaults = UserDefaults.standard
    let key = "sort"
    
    let defaultSort = Sort(sortIncomeBy: "date",
                           sortExpenseBy: "date",
                           sortDirection: true)
    func save(sort: Sort) {
        guard let data = try? JSONEncoder().encode(sort) else {return}
        userDefaults.set(data, forKey: key)
    }
    
    func fetchSort() -> Sort {
        guard let data = userDefaults.object(forKey: key) as? Data else {return defaultSort}
        guard let sort = try? JSONDecoder().decode(Sort.self, from: data) else {return defaultSort}
        return sort
    }
    
    private init() {}
}
