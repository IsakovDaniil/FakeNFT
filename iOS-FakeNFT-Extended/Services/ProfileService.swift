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
    
    // MARK: - Update Profile
    
    func loadProfile() async throws -> UserProfile {
        if let cachedProfile = await storage.getProfile() {
            Task {
                do {
                    let freshProfile = try await fetchProfileFromNetwork()
                    await storage.saveProfile(freshProfile)
                } catch {
                    print("⚠️ Background update failed: \(error)")
                }
            }
            
            return cachedProfile
        }
        
        let profile = try await fetchProfileFromNetwork()
        await storage.saveProfile(profile)
        return profile
    }
    
    // MARK: - Update Profile
    
    func updateProfile(_ profile: UserProfile) async throws -> UserProfile {
        await storage.saveProfile(profile)
        
        let request = UpdateProfileRequest(profile: profile)
        let updatedProfile: UserProfile = try await networkClient.send(request: request)
        
        await storage.saveProfile(updatedProfile)
        
        return updatedProfile
    }
    
    // MARK: - Private Methods
    
    private func fetchProfileFromNetwork() async throws -> UserProfile {
        let request = GetProfileRequest()
        let profile: UserProfile = try await networkClient.send(request: request)
        return profile
    }
}
