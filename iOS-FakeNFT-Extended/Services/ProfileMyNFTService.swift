//
//  ProfileMyNFTService.swift
//  iOS-FakeNFT-Extended
//
//  Created by Даниил on 18.02.2026.
//

import Foundation

// MARK: - Protocol

protocol ProfileMyNFTServiceProtocol {
    func fetchMyNFTs(nftIDs: [String]) async throws -> [ProfileNFT]
    func toggleFavorite(profileID: String, currentLikes: [String], nftID: String) async throws -> [String]
}

// MARK: - Implementation

final class ProfileMyNFTService: ProfileMyNFTServiceProtocol {
    
    // MARK: - Dependencies
    
    private let networkClient: NetworkClient
    
    // MARK: - Init
    
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    
    // MARK: - Public Methods
    
    func fetchMyNFTs(nftIDs: [String]) async throws -> [ProfileNFT] {
        // Загружаем все NFT параллельно
        try await withThrowingTaskGroup(of: ProfileNFT?.self) { group in
            for nftID in nftIDs {
                group.addTask {
                    try await self.fetchSingleNFT(id: nftID)
                }
            }
            
            var nfts: [ProfileNFT] = []
            for try await nft in group {
                if let nft = nft {
                    nfts.append(nft)
                }
            }
            
            return nfts
        }
    }
    
    func toggleFavorite(profileID: String, currentLikes: [String], nftID: String) async throws -> [String] {
        var updatedLikes = currentLikes
        
        if let index = updatedLikes.firstIndex(of: nftID) {
            updatedLikes.remove(at: index)
        } else {
            updatedLikes.append(nftID)
        }
        
        let request = ProfileUpdateLikesRequest(profileID: profileID, likes: updatedLikes)
        
        guard let endpoint = request.endpoint else {
            throw NetworkClientError.incorrectRequest("Empty endpoint")
        }
        
        var urlRequest = URLRequest(url: endpoint)
        urlRequest.httpMethod = request.httpMethod.rawValue
        urlRequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue(RequestConstants.token, forHTTPHeaderField: "X-Practicum-Mobile-Token")
        urlRequest.httpBody = request.createFormBody()
        
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkClientError.urlSessionError
        }
        
        guard 200 ..< 300 ~= httpResponse.statusCode else {
            throw NetworkClientError.httpStatusCode(httpResponse.statusCode)
        }
        
        let decoder = JSONDecoder()
        let profile = try decoder.decode(UserProfile.self, from: data)
        
        return profile.favoriteNfts
    }
    
    // MARK: - Private Methods
    
    private func fetchSingleNFT(id: String) async throws -> ProfileNFT? {
        let request = ProfileGetNFTRequest(nftID: id)
        
        do {
            let nft: ProfileNFT = try await networkClient.send(request: request)
            return nft
        } catch {
            print("⚠️ Failed to load NFT \(id): \(error)")
            return nil
        }
    }
}

