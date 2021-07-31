//
//  NewTripViewModel.swift
//  report
//
//  Created by osa on 21.07.2021.
//

import Foundation

protocol NewTripViewModelProtocol {
    var editingTrip: Trip? { get }
    init(editingTrip: Trip)
    init()
    
    func dateFormatToString(dateFormat: String, date: Date) -> String
    func dateFormatToDate(dateFormat: String, dateString: String) -> Date?
    func editTrip(trip: Trip, newCountry: String, newCity: String, newDate: Date)
    func saveTrip(country: String, city: String, date: Date)
}

class NewTripViewModel: NewTripViewModelProtocol {
    
    var editingTrip: Trip?
    
    required init() {}
    
    required init(editingTrip: Trip) {
        self.editingTrip = editingTrip
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
    
    func editTrip(trip: Trip, newCountry: String, newCity: String, newDate: Date) {
        StorageManager.shared.editTrip(trip: trip,
                                       newCountry: newCountry,
                                       newCity: newCity,
                                       newDate: newDate)
    }
    
    func saveTrip(country: String, city: String, date: Date) {
        let trip = Trip(value: [country, city, date])
        StorageManager.shared.saveTrip(trip: trip)
    }
}
