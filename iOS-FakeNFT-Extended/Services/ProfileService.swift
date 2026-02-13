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
}
