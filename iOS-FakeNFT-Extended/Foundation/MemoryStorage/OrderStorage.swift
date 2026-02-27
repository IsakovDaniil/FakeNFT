//
//  OrderStorage.swift
//  iOS-FakeNFT-Extended
//
//  Created by Султан Ахметбек on 08.02.2026.
//

import Foundation

protocol OrderStorage: AnyObject {
    func saveOrder(_ order: Order) async
    func getOrder() async -> Order?
}

actor OrderStorageImpl: OrderStorage {
    private var storage: [String: Order] = [:]

    func saveOrder(_ order: Order) async {
        storage["1"] = order
    }

    func getOrder() async -> Order? {
        storage["1"]
    }
}
