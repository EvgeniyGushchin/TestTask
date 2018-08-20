//
//  ExchangeRatesTable.swift
//  CurrenciesTable
//
//  Created by Evgeniy Gushchin on 20/08/2018.
//

import Foundation

struct ExchangeRatesTable : Codable {
    let base: String
    let date: String
    let rates: [String: Double]
}
