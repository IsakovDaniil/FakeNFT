//
//  OrderService.swift
//  iOS-FakeNFT-Extended
//
//  Created by Владимир Брюковкин on 16.02.2026.
//

import Foundation

protocol OrderService: Sendable {
    func fetchOrder() async throws -> Order
}

actor OrderServiceImpl: OrderService {
    private let networkClient: NetworkClient

    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }

    func fetchOrder() async throws -> Order {
        let request = OrderRequest()
        return try await networkClient.send(request: request)
    }
}
