//
//  FavouritesNFTViewModel.swift
//  iOS-FakeNFT-Extended
//
//  Created by Даниил on 22.02.2026.
//

import Foundation
import Observation

@Observable
@MainActor
final class FavoriteFTViewModel {

    // MARK: - Dependencies

    private let profileService: ProfileServiceProtocol
    private let nftService: ProfileMyNFTServiceProtocol
    private var currentProfile: UserProfile?

    // MARK: - State

    enum ViewState {
        case loading
        case loaded
        case empty
        case error(Error)
    }

    var state: ViewState = .loading

    // MARK: - NFTs

    private(set) var nfts: [ProfileNFT] = []

    // MARK: - Alert State

    var showErrorAlert = false
    var errorMessage: String?

    // MARK: - Computed Properties

    var isLoading: Bool {
        if case .loading = state { return true }
        return false
    }

    // MARK: - Init

    init(
        profileService: ProfileServiceProtocol,
        nftService: ProfileMyNFTServiceProtocol
    ) {
        self.profileService = profileService
        self.nftService = nftService
    }

    // MARK: - Methods

    func loadFavorites() async {
        state = .loading

        do {
            let profile = try await profileService.loadProfile(forceRefresh: true)
            currentProfile = profile

            guard !profile.favoriteNfts.isEmpty else {
                nfts = []
                state = .empty
                return
            }

            var fetchedNFTs = try await nftService.fetchMyNFTs(nftIDs: profile.favoriteNfts)
            let favoriteSet = Set(profile.favoriteNfts)
            for i in fetchedNFTs.indices {
                fetchedNFTs[i].isFavorite = favoriteSet.contains(fetchedNFTs[i].id)
            }

            nfts = fetchedNFTs
            state = nfts.isEmpty ? .empty : .loaded

        } catch {
            handleError(error)
        }
    }

    func retry() async {
        await loadFavorites()
    }

    func removeFromFavorites(_ nft: ProfileNFT) async {
        guard let profile = currentProfile else { return }

        nfts.removeAll { $0.id == nft.id }
        if nfts.isEmpty { state = .empty }

        do {
            let updatedLikes = try await nftService.toggleFavorite(
                currentLikes: profile.favoriteNfts,
                nftID: nft.id
            )
            currentProfile = profile.with(favoriteNfts: updatedLikes)

        } catch {
            var restored = nft
            restored.isFavorite = true
            nfts.append(restored)
            state = .loaded
        }
    }

    // MARK: - Private Methods

    private func handleError(_ error: Error) {
        state = .error(error)

        if let networkError = error as? NetworkClientError {
            switch networkError {
            case .httpStatusCode(let code):
                errorMessage = ProfileConstants.ErrorMessages.serverErrorPrefix + "\(code)"
            case .urlSessionError:
                errorMessage = ProfileConstants.ErrorMessages.connectionError
            case .parsingError:
                errorMessage = ProfileConstants.ErrorMessages.parsingError
            case .incorrectRequest(let message):
                errorMessage = ProfileConstants.ErrorMessages.invalidRequestPrefix + message
            case .urlRequestError:
                errorMessage = ProfileConstants.ErrorMessages.networkError
            }
        } else {
            errorMessage = ProfileConstants.defaultErrorMessage
        }

        showErrorAlert = true
    }
}
