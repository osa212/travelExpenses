//
//  Trip.swift
//  report
//
//  Created by osa on 23.05.2021.
//
 import RealmSwift

class Trip: Object {
    @objc dynamic var country = ""
    @objc dynamic var city = ""
    @objc dynamic var date = Date()
    let incomes = List<Income>()
    let expenses = List<Expense>()
}

class Income: Object {
    @objc dynamic var amount = 0.0
    @objc dynamic var currency = ""
    @objc dynamic var category = ""
    @objc dynamic var date = Date()
}

class Expense: Object {
    @objc dynamic var amount = 0.0
    @objc dynamic var currency = ""
    @objc dynamic var category = ""
    @objc dynamic var date = Date()
    
    @objc dynamic var convertedAmount = 0.0
    @objc dynamic var receipt = ""
    @objc dynamic var paymentMethod = ""
    @objc dynamic var note = ""
}
