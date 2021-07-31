//
//  NetworkManagers.swift
//  report
//
//  Created by osa on 30.05.2021.
//

import Foundation

class NetworkManager {
    static let shared = NetworkManager()
    let flagUrl = "https://www.countryflags.io/"
    let currencyUrl = "https://www.cbr-xml-daily.ru/archive/"
    
    func fetchCurrency(
        url: String,
        completion: @escaping (Result<Currency, Error>) -> Void) {
        
        guard let url = URL(string: url) else { return }
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data else {
                print(error?.localizedDescription ?? "Server error")
                return
            }
            do {
                let currencyDecoded = try JSONDecoder().decode(Currency.self, from: data)
                completion(.success(currencyDecoded))
            } catch let error {
                completion(.failure(error))
            }
        }.resume()
    }
    
    func fetchFlag(url: String) -> Data? {
        guard let url = URL(string: url) else { return Data() }
        guard let flagImage = try? Data(contentsOf: url) else { return Data() }
        return flagImage
    }
    
    private init() {}
}

