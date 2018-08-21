//
//  CurrenciesTableTests.swift
//  CurrenciesTableTests
//
//  Created by Evgeniy Gushchin on 20/08/2018.
//  Copyright © 2018 Evgeniy Gushchin. All rights reserved.
//

import XCTest
@testable import CurrenciesTable

class CurrenciesTableTests: XCTestCase {
    
    
    func testConverter() {
        let ratesTable = ExchangeRatesTable(base: "USD", date: "does'n matter", rates: ["RUB":67.24, "EUR":0.8764, "GBP":0.78418])
        let list = Converter.currencyListFor(amount: 10.0, ratesTable: ratesTable)
        XCTAssert(list.count > 0, "converter returned incorrect number of items")
        XCTAssertEqual(list[0].currencyAmount, 0.8764 * 10.0, accuracy: 0.01)
    }
   
}
