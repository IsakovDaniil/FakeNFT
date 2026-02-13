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
    func getProfile() async -> UserProfile
    func clearProfile() async
}
