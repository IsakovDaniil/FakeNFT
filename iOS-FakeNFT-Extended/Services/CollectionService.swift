//
//  CollectionService.swift
//  iOS-FakeNFT-Extended
//
//  Created by Владимир Брюковкин on 10.02.2026.
//

import Foundation

protocol CollectionService: Sendable {
    func fetchCollections() async throws -> [NFTCollection]
}

actor CollectionServiceImpl: CollectionService {
    private let networkClient: NetworkClient

    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }

    func fetchCollections() async throws -> [NFTCollection] {
        let request = CollectionsRequest()
        return try await networkClient.send(request: request)
    }
}
