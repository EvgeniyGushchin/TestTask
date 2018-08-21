//
//  File.swift
//  CurrenciesTable
//
//  Created by Evgeniy Gushchin on 20/08/2018.
//  Copyright © 2018 Evgeniy Gushchin. All rights reserved.
//

import Foundation

class Converter {
    
    class func currencyListFor(amount: Double, ratesTable: ExchangeRatesTable) -> [CurrencyItem] {
        
        let list = ratesTable.rates.keys.reduce([CurrencyItem](), { (result, key) -> [CurrencyItem] in
            var result = result
            let exRate = ratesTable.rates[key] ?? 0.0
            let item = CurrencyItem(currencyCode: key,
                                    currencyAmount: exRate * amount,
                                    currencyName: nil)
            result.append(item)
            return result
        })
        return list
    }
    
}
