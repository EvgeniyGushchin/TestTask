//
//  ApiClient.swift
//  CurrenciesTable
//
//  Created by Evgeniy Gushchin on 20/08/2018.
//  Copyright © 2018 Evgeniy Gushchin. All rights reserved.
//

import Foundation

protocol ExchangeRatesApi {
    func getExchangeRates(base: String, completion: RatesCompletion?)
    
    typealias RatesCompletion = (_ exchangeTable: ExchangeRatesTable?,_ error: Error?) -> ()
}


class ApiClient {
    
    let session = URLSession.init(configuration: .default)
    let ratesUrl = URL(string: "https://revolut.duckdns.org/latest")!
    
    func configurateRequest(url: URL,
                            httpMethod: String = "GET",
                            withParametrs: [String: Any]) -> URLRequest {
        
        var urlRequest: URLRequest
        if httpMethod == "POST" {
            urlRequest =  URLRequest(url: url)
            urlRequest.httpMethod = httpMethod
            let bodyData = try? JSONSerialization.data(withJSONObject: withParametrs, options: [])
            urlRequest.httpBody = bodyData
        } else {
            guard var urlComp = URLComponents(string: url.absoluteString) else {
                return URLRequest(url: url)
            }
            
            var items = [URLQueryItem]()
            for (key,value) in withParametrs {
                items.append(URLQueryItem(name: key, value: String(describing: value)))
            }
            urlComp.queryItems = items
            urlRequest =  URLRequest(url: urlComp.url!)
        }
        
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        return urlRequest
    }
}

extension ApiClient: ExchangeRatesApi {
    
    func getExchangeRates(base: String = "EUR", completion: RatesCompletion?) {
        
        let request = configurateRequest(url: ratesUrl, withParametrs: ["base" : base])
        
        let task = session.dataTask(with: request) { (data, response, error) in
            guard let responseData = data, error == nil else {
                print("\(String(describing: error?.localizedDescription))")
                completion?(nil, error)
                return
            }
            do {
                let decoder = JSONDecoder()
                let exchangeTable = try decoder.decode(ExchangeRatesTable.self, from: responseData)
                completion?(exchangeTable, nil)
            } catch let er {
                completion?(nil, er)
                return
            }
        }
        task.resume()
    }
}

