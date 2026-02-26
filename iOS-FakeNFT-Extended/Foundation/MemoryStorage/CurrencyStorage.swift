//
//  CurrencyStorage.swift
//  iOS-FakeNFT-Extended
//
//  Created by Султан Ахметбек on 14.02.2026.
//

import Foundation

protocol CurrencyStorage: AnyObject {
    func saveCurrencies(_ currencies: [Currency]) async
    func getCurrencies() async -> [Currency]?
}

actor CurrencyStorageImpl: CurrencyStorage {
    private var storage: [Currency]? = nil
    
    func saveCurrencies(_ currencies: [Currency]) async {
        storage = currencies
    }
    
    func getCurrencies() async -> [Currency]? {
        storage
    }
}
