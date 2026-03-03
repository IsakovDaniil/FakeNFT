//
//  ProfileMyNFTService.swift
//  iOS-FakeNFT-Extended
//
//  Created by Даниил on 18.02.2026.
//

import Foundation
import OSLog

// MARK: - Protocol

protocol ProfileMyNFTServiceProtocol {
    func fetchMyNFTs(nftIDs: [String]) async throws -> [ProfileNFT]
    func toggleFavorite(currentLikes: [String], nftID: String) async throws -> [String]
}

// MARK: - Implementation

final class ProfileMyNFTService: ProfileMyNFTServiceProtocol {
    
    // MARK: - Dependencies
    
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "app", category: "ProfileMyNFTService")
    private let networkClient: NetworkClient
    private let decoder = JSONDecoder()
    
    // MARK: - Init
    
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    
    // MARK: - Public Methods
    
    func fetchMyNFTs(nftIDs: [String]) async throws -> [ProfileNFT] {
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
    
    func toggleFavorite(currentLikes: [String], nftID: String) async throws -> [String] {
        var updatedLikes = currentLikes
        
        if let index = updatedLikes.firstIndex(of: nftID) {
            updatedLikes.remove(at: index)
        } else {
            updatedLikes.append(nftID)
        }
        
        let request = ProfileUpdateLikesRequest(likes: updatedLikes)
        let data = try await networkClient.send(request: request)
        if data.isEmpty {
            return updatedLikes
        }
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
            logger.warning("Failed to load NFT \(id): \(error.localizedDescription)")
            return nil
        }
    }
}
