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
    
    private let store: ProfileStateStore
    
    // MARK: - Alert State
    
    var showErrorAlert = false
    var errorMessage: String?
    
    // MARK: - Computed Properties
    
    var nfts: [ProfileNFT] { store.favoriteNFTs }
    
    enum ViewState { case loading, loaded, empty, error(String) }
    
    var state: ViewState {
        switch store.loadingState {
        case .idle, .loading:
            return .loading
        case .error(let msg):
            return .error(msg)
        case .loaded where nfts.isEmpty:
            return .empty
        case .loaded:
            return .loaded
        }
    }
    
    var isLoading: Bool {
        if case .loading = store.loadingState { return true }
        return false
    }
    
    // MARK: - Init
    
    init(store: ProfileStateStore) {
        self.store = store
    }
    
    // MARK: - Methods
    
    func loadFavorites() async {
        await store.loadAll()
        syncError()
    }
    
    func retry() async {
        await store.loadAll(forceRefresh: true)
        syncError()
    }
    
    func removeFromFavorites(_ nft: ProfileNFT) async {
        let success = await store.removeFromFavorites(nftID: nft.id)
        if !success {
            errorMessage = ProfileConstants.defaultErrorMessage
            showErrorAlert = true
        }
    }
    
    // MARK: - Private
    
    private func syncError() {
        if case .error(let msg) = store.loadingState {
            errorMessage = msg
            showErrorAlert = true
        }
    }
}
