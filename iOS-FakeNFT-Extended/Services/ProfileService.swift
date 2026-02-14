//
//  ProfileService.swift
//  iOS-FakeNFT-Extended
//
//  Created by Даниил on 13.02.2026.
//

import Foundation

// MARK: - Profile Service Protocol

protocol ProfileServiceProtocol {
    func loadProfile(forceRefresh: Bool) async throws -> UserProfile
    func updateProfile(_ profile: UserProfile) async throws -> UserProfile
}

// MARK: - Profile Service Implementation

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
    
    // MARK: - Load Profile
    
    func loadProfile(forceRefresh: Bool = false) async throws -> UserProfile {
        if !forceRefresh, let cachedProfile = await storage.getProfile() {
            Task {
                do {
                    let freshProfile = try await fetchProfileFromNetwork()
                    await storage.saveProfile(freshProfile)
                } catch {
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
        let request = UpdateProfileRequest(profile: profile)
        
        guard let endpoint = request.endpoint else {
            throw NetworkClientError.incorrectRequest("Empty endpoint")
        }
        
        var urlRequest = URLRequest(url: endpoint)
        urlRequest.httpMethod = "PUT"
        urlRequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue(RequestConstants.token, forHTTPHeaderField: "X-Practicum-Mobile-Token")
        
        let body = request.createFormBody()
        urlRequest.httpBody = body
        
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkClientError.urlSessionError
        }
        
        guard 200 ..< 300 ~= httpResponse.statusCode else {
            throw NetworkClientError.httpStatusCode(httpResponse.statusCode)
        }
        
        let decoder = JSONDecoder()
        let updatedProfile = try decoder.decode(UserProfile.self, from: data)
        
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
