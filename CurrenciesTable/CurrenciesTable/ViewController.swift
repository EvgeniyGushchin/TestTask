//
//  ViewController.swift
//  CurrenciesTable
//
//  Created by Evgeniy Gushchin on 20/08/2018.
//  Copyright © 2018 Evgeniy Gushchin. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    
    @IBOutlet weak var currenciesTable: UITableView!

    @IBOutlet weak var baseCurrencyCodeLabel: UILabel!
    @IBOutlet weak var baseCurrencyAmountField: UITextField!
    
    let disposeBag = DisposeBag()
    
    var apiClient = ApiClient()
    var viewModel: CurrenciesTableViewModel?
    
    let currentCurrency = Variable(CurrencyItem(currencyCode: "USD", currencyAmount: 100.0, currencyName: nil))
    let currencyAmount = Variable(100.0)
    let isTyping = Variable(false)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = CurrenciesTableViewModel(apiClient: apiClient, currentCurrency: currentCurrency.value)
        
        baseCurrencyAmountField.rx.controlEvent([.editingChanged])
            .asObservable()
            .subscribe(onNext: { () in
                self.isTyping.value = true
            })
            .disposed(by: disposeBag)
    
        let input =  CurrenciesTableViewModel.Input(isTyping: isTyping.asObservable(),
                                                    currencyAmount: currencyAmount.asObservable(),
                                                    selectedCurrency: currentCurrency.asObservable())
        if let output = viewModel?.transform(input: input) {
            bindTableView(output: output)
            
            output.baseCurrency.drive(onNext: { (item) in
                self.baseCurrencyAmountField.text = String(format: "%.2f", item.currencyAmount)
                self.baseCurrencyCodeLabel.text = item.currencyCode
            }).disposed(by: disposeBag)
        }
        
        baseCurrencyAmountField.rx.text
            .debounce(0.5, scheduler: MainScheduler.instance)
            .subscribe(onNext: { text in
                if let text = text, let amount = Double(text) {
                    self.currencyAmount.value = amount
                    self.isTyping.value = false
                }
            })
            .disposed(by: disposeBag)
    }
    
    func bindTableView(output: CurrenciesTableViewModel.Output) {
        
        output.currenciesList.drive(currenciesTable.rx.items(cellIdentifier: "Simple Cell")){ index, currencyItem, cell in
            if let cell = cell as? CurrencyCell {
                cell.currencyCodeLabel.text = currencyItem.currencyCode
                cell.currencyAmountField.text = String(format: "%.2f", currencyItem.currencyAmount)
                cell.currencyAmountField.isUserInteractionEnabled = false
            }
            }
            .disposed(by:disposeBag)
        
        currenciesTable.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                let cell = self?.currenciesTable.cellForRow(at: indexPath) as? CurrencyCell
                if let code = cell?.currencyCodeLabel.text, let value = cell?.currencyAmountField.text , let amount = Double(value) {
                    let item = CurrencyItem(currencyCode: code, currencyAmount: amount, currencyName: nil)
                    self?.currentCurrency.value = item
                }
            })
            .disposed(by:disposeBag)
    }
}

