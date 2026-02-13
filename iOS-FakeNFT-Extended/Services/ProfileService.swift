//
//  ProfileService.swift
//  iOS-FakeNFT-Extended
//
//  Created by Даниил on 13.02.2026.
//

import Foundation

// MARK: - Profile Service Protocol

protocol ProfileServiceProtocol {
    func loadProfile() async throws -> UserProfile
    func updateProfile(_ profile: UserProfile) async throws -> UserProfile
}

@MainActor
final class ProfileService: ProfileServiceProtocol {
    
    private let networkClient: NetworkClient
    private let storage: ProfileStorageProtocol
    
    init(
        networkClient: NetworkClient,
        storage: ProfileStorageProtocol
    ) {
        self.networkClient = networkClient
        self.storage = storage
    }
    
    func loadProfile() async throws -> UserProfile {
        if let cachedProfile = await storage.getProfile() {
            Task {
                do {
                    let freshProfile = try await fetchProf
                }
            }
        }
    }
    
    // MARK: - Private Methods
    
    private func fetchProfileFromNetwork() async throws -> UserProfile {
        
    }
}
