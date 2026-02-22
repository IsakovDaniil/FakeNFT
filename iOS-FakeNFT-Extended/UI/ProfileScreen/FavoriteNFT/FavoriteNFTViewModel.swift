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
final class FavoriteNFTViewModel {

    // MARK: - Dependencies

    private let profileService: ProfileServiceProtocol
    private let nftService: ProfileMyNFTServiceProtocol
    private var currentProfile: UserProfile?

    // MARK: - State

    enum ViewState {
        case loading
        case loaded
        case empty
        case error(String)
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
            for index in fetchedNFTs.indices {
                fetchedNFTs[index].isFavorite = favoriteSet.contains(fetchedNFTs[index].id)
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
            let message: String

            if let networkError = error as? NetworkClientError {
                switch networkError {
                case .httpStatusCode(let code):
                    message = ProfileConstants.ErrorMessages.serverErrorPrefix + "\(code)"
                case .urlSessionError:
                    message = ProfileConstants.ErrorMessages.connectionError
                case .parsingError:
                    message = ProfileConstants.ErrorMessages.parsingError
                case .incorrectRequest(let details):
                    message = ProfileConstants.ErrorMessages.invalidRequestPrefix + details
                case .urlRequestError:
                    message = ProfileConstants.ErrorMessages.networkError
                }
            } else {
                message = ProfileConstants.defaultErrorMessage
            }

            errorMessage = message
            state = .error(message)
            showErrorAlert = true
        }
    }

