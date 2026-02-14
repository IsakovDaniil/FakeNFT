//
//  ProfileStorage.swift
//  iOS-FakeNFT-Extended
//
//  Created by Даниил on 13.02.2026.
//

import Foundation

// MARK: - Profile Storage Protocol

protocol ProfileStorageProtocol: AnyObject {
    func saveProfile(_ profile: UserProfile) async
    func getProfile() async -> UserProfile?
    func clearProfile() async
}

// MARK: - Profile Storage Actor

actor ProfileStorage: ProfileStorageProtocol {
    
    // MARK: - Nested Types
    
    private enum Keys {
        static let profile = "cached_user_profile"
    }
    
    // MARK: - Properties
    
    private let userDefaults: UserDefaults
    private let encoder: JSONEncoder
    private let decoder: JSONDecoder
    
    // MARK: - Initializer
    
    init(
        userDefaults: UserDefaults = .standard,
        encoder: JSONEncoder = JSONEncoder(),
        decoder: JSONDecoder = JSONDecoder()
    ) {
        self.userDefaults = userDefaults
        self.encoder = encoder
        self.decoder = decoder
    }
    
    // MARK: - Public Methods
    
    func saveProfile(_ profile: UserProfile) async {
        guard let data = try? encoder.encode(profile) else { return }
        
        userDefaults.set(data, forKey: Keys.profile)
    }
    
    func getProfile() async -> UserProfile? {
        guard let data = userDefaults.data(forKey: Keys.profile) else { return nil }
        
        guard let profile = try? decoder.decode(UserProfile.self, from: data) else { return nil }
        
        return profile
    }
    
    func clearProfile() async {
        userDefaults.removeObject(forKey: Keys.profile)
    }
    
}
