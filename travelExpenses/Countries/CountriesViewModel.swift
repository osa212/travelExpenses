//
//  CountriesViewModel.swift
//  report
//
//  Created by osa on 18.07.2021.
//

import Foundation

protocol CountriesViewModelProtocol {
    var countries: [Country] { get }
    var filteredCountries: Box<[Country]> { get }
}

class CountriesViewModel: CountriesViewModelProtocol {
    
    var filteredCountries: Box<[Country]> = Box([])
    
    var countries: [Country] {
        DataManager.shared.countries
    }
}
