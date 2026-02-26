//
//  CurrencyMock.swift
//  iOS-FakeNFT-Extended
//
//  Created by Султан Ахметбек on 13.02.2026.
//

import Foundation

enum CurrencyMock {
    static var mockCurrency: Currency {
        Currency(
            id: "0",
            title: "Shiba_Inu",
            name: "SHIB",
            imageUrl: URL(string: "https://code.s3.yandex.net/Mobile/iOS/Currencies/Shiba_Inu_(SHIB).png")!
        )
    }
    
    static let mockCurrencies: [Currency] = [
        Currency(
            id: "0",
            title: "Shiba_Inu",
            name: "SHIB",
            imageUrl: URL(string: "https://code.s3.yandex.net/Mobile/iOS/Currencies/Shiba_Inu_(SHIB).png")!
        ),
        Currency(
            id: "1",
            title: "Cardano",
            name: "ADA",
            imageUrl: URL(string: "https://code.s3.yandex.net/Mobile/iOS/Currencies/Cardano_(ADA).png")!
        ),
        Currency(
            id: "2",
            title: "Tether",
            name: "USDT",
            imageUrl: URL(string: "https://code.s3.yandex.net/Mobile/iOS/Currencies/Tether_(USDT).png")!
        ),
        Currency(
            id: "3",
            title: "ApeCoin",
            name: "APE",
            imageUrl: URL(string: "https://code.s3.yandex.net/Mobile/iOS/Currencies/ApeCoin_(APE).png")!
        ),
        Currency(
            id: "4",
            title: "Solana",
            name: "SOL",
            imageUrl: URL(string: "https://code.s3.yandex.net/Mobile/iOS/Currencies/Solana_(SOL).png")!
        ),
        Currency(
            id: "5",
            title: "Bitcoin",
            name: "BITCOIN",
            imageUrl: URL(string: "https://code.s3.yandex.net/Mobile/iOS/Currencies/Bitcoin_(BTC).png")!
        ),
        Currency(
            id: "6",
            title: "Dogecoin",
            name: "DOGECOIN",
            imageUrl: URL(string: "https://code.s3.yandex.net/Mobile/iOS/Currencies/Dogecoin_(DOGE).png")!
        ),
        Currency(
            id: "7",
            title: "Ethereum",
            name: "ETHEREUM",
            imageUrl: URL(string: "https://code.s3.yandex.net/Mobile/iOS/Currencies/Ethereum_(ETH).png")!
        )
    ]
}
