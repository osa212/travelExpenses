//
//  TripsViewModel.swift
//  report
//
//  Created by osa on 21.07.2021.
//

import Foundation
import RealmSwift

protocol TripsViewModelProtocol {
    var trips: Results<Trip> { get }
    var filteredTrips: Box<[Trip]> { get }
    
    func dateFormatToString(dateFormat: String, date: Date) -> String
    func getImage(index: Int) -> Data
    func deleteTrip(trip: Trip)
    
    func newTripEditingViewModel(trip: Trip) -> NewTripViewModelProtocol
    func newTripViewModel() -> NewTripViewModelProtocol
    func expensesViewModel(indexPath: IndexPath) -> OperationsViewModelProtocol
    func expensesViewModelFilter(indexPath: IndexPath) -> OperationsViewModelProtocol
}

class TripsViewModel: TripsViewModelProtocol {
    
    var trips: Results<Trip> {
        StorageManager.shared.realm.objects(Trip.self)
    }
    
    var filteredTrips: Box<[Trip]> = Box([])

    func dateFormatToString(dateFormat: String, date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        return dateFormatter.string(from: date)
    }
    
    func getImage(index: Int) -> Data {
        for country in DataManager.shared.countries {
            if country.name == trips[index].country {
                let url = "\(NetworkManager.shared.flagUrl)\(country.code)/shiny/64.png"
                guard let urlForCach = URL(string: url) else { return Data() }
                
                if let cachedImage = getCachedImage(from: urlForCach) {
                    return cachedImage
                }
                guard let data = NetworkManager.shared.fetchFlag(url: url) else { return Data()}
                self.saveDataToCash(data: data, response: URLResponse())
                return data
            }
        }
        return Data()
    }
    
    private func saveDataToCash(data: Data, response: URLResponse) {
            let cachedResponse = CachedURLResponse(response: response, data: data)
            
            guard let url = response.url else {return}
            let request = URLRequest(url: url)
            URLCache.shared.storeCachedResponse(cachedResponse,
                                                for: request)
    }
    
    private func getCachedImage(from url: URL) -> Data? {
        let request = URLRequest(url: url)
        if let cachedResponse = URLCache.shared.cachedResponse(for: request) {
            return Data(cachedResponse.data)
        }
        return nil
    }
    
    func newTripEditingViewModel(trip: Trip) -> NewTripViewModelProtocol {
        return NewTripViewModel(editingTrip: trip)
    }
    
    func newTripViewModel() -> NewTripViewModelProtocol {
        return NewTripViewModel()
    }
    
    func expensesViewModel(indexPath: IndexPath) -> OperationsViewModelProtocol {
        let trip = trips[indexPath.row]
        return OperationsViewModel(trip: trip)
    }
    
    func expensesViewModelFilter(indexPath: IndexPath) -> OperationsViewModelProtocol {
        let trip = filteredTrips.value[indexPath.row]
        return OperationsViewModel(trip: trip)
    }
    
    func deleteTrip(trip: Trip) {
        StorageManager.shared.deleteTrip(trip: trip)
    }
    
}
