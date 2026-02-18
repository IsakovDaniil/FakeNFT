//
//  MyNFTService.swift
//  iOS-FakeNFT-Extended
//
//  Created by Даниил on 18.02.2026.
//

import Foundation

protocol ProfileMyNFTServiceProtocol {
    func fetchMyNFTs() async throws -> [ProfileNFT]
    func toggleFavorite(nftID: String) async throws
}

final class ProfileMyNFTService: ProfileMyNFTServiceProtocol {
    
    // MARK: - Properties
    
    private var cachedNFTs: [ProfileNFT] = []
    
    // MARK: - Public Methods
    
    func fetchMyNFTs() async throws -> [ProfileNFT] {
        try await Task.sleep(nanoseconds: 1_000_000_000)
        
        if !cachedNFTs.isEmpty {
            return cachedNFTs
        }
        
        cachedNFTs = ProfileNFT.mockData
        
        return cachedNFTs
        
    }
    
    func toggleFavorite(nftID: String) async throws {
        try await Task.sleep(nanoseconds: 1_000_000_000)
        
        if let index = cachedNFTs.firstIndex(where: { $0.id == nftID }) {
            cachedNFTs[index].isFavorite.toggle()
        }
        
    }
    
}

// MARK: - Mock Service для Preview

final class MockProfileMyNFTService: ProfileMyNFTServiceProtocol {
    var mockNFTs: [ProfileNFT]
    var shouldFail = false
    
    init(mockNFTs: [ProfileNFT] = ProfileNFT.mockData) {
        self.mockNFTs = mockNFTs
    }
    
    func fetchMyNFTs() async throws -> [ProfileNFT] {
        try await Task.sleep(nanoseconds: 500_000_000)
        
        if shouldFail {
            throw NSError(domain: "MockError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Mock error"])
        }
        
        return mockNFTs
    }
    
    func toggleFavorite(nftID: String) async throws {
        if let index = mockNFTs.firstIndex(where: { $0.id == nftID }) {
            mockNFTs[index].isFavorite.toggle()
        }
    }
}
