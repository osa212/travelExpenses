//
//  CurrencyViewModel.swift
//  report
//
//  Created by osa on 20.07.2021.
//

import Foundation

protocol CurrencyViewModelProtocol {
    var currencyNames: [String] { get }
    var currencyRussianNames: [String] { get }
    var filteredString: Box<[String]> { get }
    
    var choosenDate: String? { get }
    
    var currencies: [CurrencyName] { get }
    var filteredCUR: Box<[CurrencyName]> { get }
    
    init(choosenDate: String?)
    
    func fetchCurrency()
}

class CurrencyViewModel: CurrencyViewModelProtocol {
    var choosenCurrency: CurrencyName?
    
    var choosenDate: String?
    
    required init(choosenDate: String?) {
        self.choosenDate = choosenDate
    }
    
    var currencies: [CurrencyName] = []
    var filteredCUR: Box<[CurrencyName]> = Box([])
    
    var currencyNames: [String] {
        DataManager.shared.currencyNames
    }
    var currencyRussianNames: [String] {
        DataManager.shared.currencyRussianNames
    }
    var filteredString: Box<[String]> = Box([])
    
    func fetchCurrency() {
        guard let date = choosenDate else { return }
        let url = NetworkManager.shared.currencyUrl
        NetworkManager.shared.fetchCurrency(url: "\(url)\(date)/daily_json.js") { [unowned self] result in
            switch result {
            case .success(let data):
                
                guard let valute = data.Valute else { return }
                
                let mirror = Mirror(reflecting: valute)
                let names = Array(mirror.children)
                
                let arrayOfCurencies = names.map { $0.value }
                guard let castedCurrensies = arrayOfCurencies as? [CurrencyName] else { return }
                let rub = CurrencyName(CharCode: "RUB",
                                       Nominal: 1,
                                       Value: 1,
                                       Name: "Российский рубль")
                currencies.append(rub)
                currencies.append(contentsOf: castedCurrensies)
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
