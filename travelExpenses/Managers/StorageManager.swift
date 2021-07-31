//
//  StorageManager.swift
//  report
//
//  Created by osa on 24.05.2021.
//

import RealmSwift

class StorageManager {
    static let shared = StorageManager()
    
    let realm = try! Realm()
    
    private init() {}
}

extension StorageManager {
    private func write(_ completion: () -> Void) {
        do {
            try realm.write({
                completion()
            })
        } catch let error {
            print(error.localizedDescription)
        }
    }
    // MARK: -  Methods for Trip
    func saveTrip(trip: Trip) {
        write {
            realm.add(trip)
        }
    }
    
    func deleteTrip(trip: Trip) {
        write {
            realm.delete(trip.incomes)
            realm.delete(trip.expenses)
            realm.delete(trip)
        }
    }
    
    func editTrip(trip: Trip, newCountry: String, newCity: String, newDate: Date) {
        write {
            trip.city = newCity
            trip.country = newCountry
            trip.date = newDate
        }
    }
    
    // MARK: -  Methods for expenses
    func saveExpense(expense: Expense, trip: Trip) {
        write {
            trip.expenses.append(expense)
        }
    }
    
    func deleteExpense(expense: Expense) {
        write {
            realm.delete(expense)
        }
    }
    
    func editExpense(expense: Expense,
                     amount: Double,
                     currency: String,
                     category: String,
                     date: Date,
                     convertedAmount: Double,
                     receipt: String,
                     method: String,
                     note: String)
    {
        write {
            expense.amount = amount
            expense.currency = currency
            expense.category = category
            expense.date = date
            expense.convertedAmount = convertedAmount
            expense.receipt = receipt
            expense.paymentMethod = method
            expense.note = note
        }
    }
    
    // MARK: -  Methods for incomes
    func saveIncome(income: Income, trip: Trip) {
        write {
            trip.incomes.append(income)
        }
    }
    
    func deleteIncome(income: Income) {
        write {
            realm.delete(income)
        }
    }
    
    func editIncome(income: Income, amount: Double, date: Date, category: String, currency: String) {
        write {
            income.amount = amount
            income.date = date
            income.category = category
            income.currency = currency
        }
    }
}
