//
//  CatalogProfileService.swift
//  iOS-FakeNFT-Extended
//
//  Created by Владимир Брюковкин on 16.02.2026.
//

import Foundation

protocol CatalogProfileService: Sendable {
    func fetchProfile() async throws -> CatalogProfile
}

actor CatalogProfileServiceImpl: CatalogProfileService {
    private let networkClient: NetworkClient

    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }

    func fetchProfile() async throws -> CatalogProfile {
        let request = CatalogProfileRequest()
        return try await networkClient.send(request: request)
    }
}
