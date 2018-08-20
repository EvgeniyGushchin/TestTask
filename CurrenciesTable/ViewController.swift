//
//  ViewController.swift
//  CurrenciesTable
//
//  Created by Evgeniy Gushchin on 20/08/2018.
//  Copyright © 2018 Evgeniy Gushchin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var currenciesTable: UITableView!
    
    let apiClient = ApiClient()
    override func viewDidLoad() {
        super.viewDidLoad()
        apiClient.getExchangeRates { (table, error) in
            if let table = table {
                print(table)
            }
        }
        // Do any additional setup after loading the view, typically from a nib.
    }
}

