//
//  ProfileService.swift
//  iOS-FakeNFT-Extended
//
//  Created by Владимир Брюковкин on 16.02.2026.
//

import Foundation

protocol ProfileService: Sendable {
    func fetchProfile() async throws -> Profile
}

actor ProfileServiceImpl: ProfileService {
    private let networkClient: NetworkClient

    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }

    func fetchProfile() async throws -> Profile {
        let request = ProfileRequest()
        return try await networkClient.send(request: request)
    }
}
