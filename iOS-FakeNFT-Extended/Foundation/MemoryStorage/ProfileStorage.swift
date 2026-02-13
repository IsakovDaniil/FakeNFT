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

actor ProfileStorage: ProfileStorageProtocol {
    
    private enum Keys {
        static let profile = "cached_user_profile"
    }
    
    private let userDefaults: UserDefaults
    private let encoder: JSONEncoder
    private let decoder: JSONDecoder
    
    init(
        userDefaults: UserDefaults,
        encoder: JSONEncoder,
        decoder: JSONDecoder
    ) {
        self.userDefaults = userDefaults
        self.encoder = encoder
        self.decoder = decoder
    }
    
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
