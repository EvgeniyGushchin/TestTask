//
//  ViewModelProtocol.swift
//  CurrenciesTable
//
//  Created by Evgeniy Gushchin on 20/08/2018.
//

protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input) -> Output
}
