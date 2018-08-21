//
//  CurrenciesViewModel.swift
//  CurrenciesTable
//
//  Created by Evgeniy Gushchin on 20/08/2018.
//

import Foundation
import RxSwift
import RxCocoa

class CurrenciesTableViewModel: ViewModelType {
    
    struct Input {
        let isTyping: Observable<Bool>
        let currencyAmount: Observable<Double>
        let selectedCurrency: Observable<CurrencyItem>
    }
    
    struct Output {
        let currenciesList: Driver<[CurrencyItem]>
        let baseCurrency: Driver<CurrencyItem>
    }
    
    let bag = DisposeBag()
    let apiClient: ExchangeRatesApi
    let items = Variable<[CurrencyItem]>([])
    var exchangeTable: Variable<ExchangeRatesTable>?
    var currentCurrency: Variable<CurrencyItem>!
    var currentAmount :Double
    let timer: Observable<NSInteger>
    
    init(apiClient: ExchangeRatesApi = ApiClient(), currentCurrency: CurrencyItem) {
        self.apiClient = apiClient
        self.currentCurrency = Variable(currentCurrency)
        self.currentAmount = currentCurrency.currencyAmount
        self.timer = Observable<NSInteger>.interval(1, scheduler: SerialDispatchQueueScheduler.init(internalSerialQueueName: "Timer"))
        getRatesTable(base: currentCurrency.currencyCode)
    }
    
    func transform(input: Input) -> Output {
        
        input.selectedCurrency
            .subscribe(onNext: { (item) in
                self.currentCurrency.value = item
                self.updateCurrenciesList(base: item.currencyCode, amount: item.currencyAmount)
            })
            .disposed(by: bag)
        input.currencyAmount
            .subscribe(onNext: { amount in
                self.currentAmount = amount
                if let exchangeTable = self.exchangeTable {
                    self.items.value = Converter.currencyListFor(amount: amount, ratesTable: exchangeTable.value)
                }
            })
        .disposed(by: bag)
        setupTimerHandler(input: input)

        return Output(currenciesList: items.asDriver(), baseCurrency: currentCurrency.asDriver())
    }
    
    fileprivate func setupTimerHandler(input: Input) {
        timer
            .withLatestFrom(input.isTyping)
            .subscribe(onNext: { (isTyping) in
                if !isTyping {
                    self.getRatesTable(base: self.currentCurrency.value.currencyCode)
                }
            })
            .disposed(by: bag)
    }
    
    fileprivate func setupRatesHandler() {
        exchangeTable?.asObservable()
            .subscribe(onNext: { (rateTable) in
                self.items.value = Converter.currencyListFor(amount: self.currentAmount, ratesTable: rateTable)
            })
            .disposed(by: bag)
    }
    
    fileprivate func updateCurrenciesList(base: String, amount: Double) {
        apiClient.getExchangeRates(base: base, completion: {[weak self] (rates, error) in
            if let rates = rates {
                self?.items.value = Converter.currencyListFor(amount: amount, ratesTable: rates)
            }
        })
    }
    
    fileprivate func getRatesTable(base: String) {
        apiClient.getExchangeRates(base: base) { (rates, error) in
            if let rates = rates {
                if self.exchangeTable != nil {
                    self.exchangeTable?.value = rates
                    self.setupRatesHandler()
                }
                else {
                    self.exchangeTable = Variable(rates)
                }
            }
        }
    }
}
