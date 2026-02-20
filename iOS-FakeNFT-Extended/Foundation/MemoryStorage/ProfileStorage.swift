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
    
    private enum Keys {
        static let profile = "cached_user_profile"
    }
    
    private let storage: UserDefaultsStorage
    
    init(storage: UserDefaultsStorage = UserDefaultsStorage()) {
        self.storage = storage
    }
    
    func saveProfile(_ profile: UserProfile) async {
        storage.save(profile, forKey: Keys.profile)
    }
    
    func getProfile() async -> UserProfile? {
        storage.load(forKey: Keys.profile)
    }
    
    func clearProfile() async {
        storage.remove(forKey: Keys.profile)
    }
}
