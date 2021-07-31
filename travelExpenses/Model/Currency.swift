//
//  Currency.swift
//  report
//
//  Created by osa on 30.05.2021.
//

struct Currency: Decodable {
    let Date: String?
    let Valute: Valute?
}

struct Valute: Decodable {
    let AUD: CurrencyName?
    let AZN: CurrencyName?
    let GBP: CurrencyName?
    let AMD: CurrencyName?
    let BYN: CurrencyName?
    let BGN: CurrencyName?
    let BRL: CurrencyName?
    let HUF: CurrencyName?
    let HKD: CurrencyName?
    let DKK: CurrencyName?
    let USD: CurrencyName?
    let EUR: CurrencyName?
    let INR: CurrencyName?
    let KZT: CurrencyName?
    let CAD: CurrencyName?
    let KGS: CurrencyName?
    let CNY: CurrencyName?
    let MDL: CurrencyName?
    let NOK: CurrencyName?
    let PLN: CurrencyName?
    let RON: CurrencyName?
    let XDR: CurrencyName?
    let SGD: CurrencyName?
    let TJS: CurrencyName?
    let TRY: CurrencyName?
    let UZS: CurrencyName?
    let TMT: CurrencyName?
    let UAH: CurrencyName?
    let CZK: CurrencyName?
    let SEK: CurrencyName?
    let CHF: CurrencyName?
    let ZAR: CurrencyName?
    let KRW: CurrencyName?
    let JPY: CurrencyName?
}

struct CurrencyName: Decodable {
    let CharCode: String?
    let Nominal: Double?
    let Value: Double?
    let Name: String?
}


    
    



