//
//  ProfileStateStore.swift
//  iOS-FakeNFT-Extended
//  Единый источник правды для профиля, «Моих NFT» и «Избранного».
//  Все три экрана читают данные отсюда - загрузка происходит один раз.
//  Created by Даниил on 24.02.2026.
//

import Foundation
import Observation
import OSLog

@Observable
@MainActor
final class ProfileStateStore {
    
    // MARK: - Dependencies
    
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "app", category: "ProfileStateStore")
    private let profileService: ProfileServiceProtocol
    private let nftService: ProfileMyNFTServiceProtocol
    
    // MARK: - Public State
    
    private(set) var profile: UserProfile?
    private(set) var myNFTs: [ProfileNFT] = []
    private(set) var favoriteNFTs: [ProfileNFT] = []
    
    enum LoadingState {
        case idle, loading, refreshing, loaded, error(String)
    }
    
    private(set) var loadingState: LoadingState = .idle
    
    // MARK: - Init
    
    init(
        profileService: ProfileServiceProtocol,
        nftService: ProfileMyNFTServiceProtocol
    ) {
        self.profileService = profileService
        self.nftService = nftService
    }
    
    // MARK: - Load All
    
    func loadAll(forceRefresh: Bool = false) async {
        guard forceRefresh || profile == nil else { return }
        
        if profile == nil {
            loadingState = .loading
        } else {
            loadingState = .refreshing
        }
        
        do {
            let fetchedProfile = try await profileService.loadProfile(forceRefresh: forceRefresh)
            
            async let myNFTsTask = nftService.fetchMyNFTs(nftIDs: fetchedProfile.myNfts)
            async let favNFTsTask = nftService.fetchMyNFTs(nftIDs: fetchedProfile.favoriteNfts)
            
            let (fetchedMy, fetchedFav) = try await (myNFTsTask, favNFTsTask)
            
            let favoriteSet = Set(fetchedProfile.favoriteNfts)
            
            profile = fetchedProfile
            myNFTs = fetchedMy.map { nft in
                var copy = nft
                copy.isFavorite = favoriteSet.contains(nft.id)
                return copy
            }
            favoriteNFTs = fetchedFav.map { nft in
                var copy = nft
                copy.isFavorite = true
                return copy
            }
            
            loadingState = .loaded
            
        } catch {
            loadingState = .error(errorMessage(from: error))
            logger.error("Failed to load profile data: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Toggle Favorite
    
    @discardableResult
    func toggleFavorite(nftID: String) async -> Bool {
        guard let currentProfile = profile else { return false }
        
        let wasLiked = currentProfile.favoriteNfts.contains(nftID)
        
        myNFTs = myNFTs.map { nft in
            guard nft.id == nftID else { return nft }
            
            var copy = nft
            copy.isFavorite = !wasLiked
            return copy
        }
        
        if wasLiked {
            favoriteNFTs.removeAll { $0.id == nftID }
        } else {
            if let nft = myNFTs.first(where: { $0.id == nftID }) {
                favoriteNFTs.append(nft)
            }
        }
        
        var updatedLikes = currentProfile.favoriteNfts
        if wasLiked {
            updatedLikes.removeAll { $0 == nftID }
        } else {
            updatedLikes.append(nftID)
        }
        profile = currentProfile.with(favoriteNfts: updatedLikes)
        
        do {
            let confirmedLikes = try await nftService.toggleFavorite(
                currentLikes: currentProfile.favoriteNfts,
                nftID: nftID
            )
            profile = currentProfile.with(favoriteNfts: confirmedLikes)
            syncFavoriteFlag(confirmedLikes: confirmedLikes)
            return true
            
        } catch {
            logger.error("Failed to toggle favorite for NFT \(nftID): \(error.localizedDescription)")
            myNFTs = myNFTs.map { nft in
                guard nft.id == nftID else { return nft }
                
                var copy = nft
                copy.isFavorite = wasLiked
                return copy
            }
            if wasLiked {
                if let nft = myNFTs.first(where: { $0.id == nftID }) {
                    favoriteNFTs.append(nft)
                }
            } else {
                favoriteNFTs.removeAll { $0.id == nftID }
            }
            profile = currentProfile
            return false
        }
    }
    
    // MARK: - Remove From Favorites
    
    @discardableResult
    func removeFromFavorites(nftID: String) async -> Bool {
        await toggleFavorite(nftID: nftID)
    }
    
    // MARK: - Refresh
    
    func refresh() async {
        await loadAll(forceRefresh: true)
    }
    
    // MARK: - Private Helpers
    
    private func syncFavoriteFlag(confirmedLikes: [String]) {
        let favoriteSet = Set(confirmedLikes)
        myNFTs = myNFTs.map { nft in
            var copy = nft
            copy.isFavorite = favoriteSet.contains(nft.id)
            return copy
        }
        favoriteNFTs = favoriteNFTs.filter { favoriteSet.contains($0.id) }
    }
    
    private func errorMessage(from error: Error) -> String {
        if let networkError = error as? NetworkClientError {
            switch networkError {
            case .httpStatusCode(let code):
                return ProfileConstants.NetworkError.serverError + "\(code)"
            case .urlSessionError:
                return ProfileConstants.NetworkError.noConnection
            case .parsingError:
                return ProfileConstants.NetworkError.parsingError
            case .incorrectRequest(let details):
                return ProfileConstants.NetworkError.invalidRequest + details
            case .urlRequestError:
                return ProfileConstants.NetworkError.networkError
            }
        }
        return ProfileConstants.NetworkError.unknown
    }
}
