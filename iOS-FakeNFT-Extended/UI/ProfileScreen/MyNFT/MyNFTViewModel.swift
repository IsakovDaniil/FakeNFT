//
//  MyNFTViewModel.swift
//  iOS-FakeNFT-Extended
//
//  Created by Даниил on 18.02.2026.
//

import Foundation
import Observation

@Observable
@MainActor
final class MyNFTViewModel {

    // MARK: - Dependencies

    private let store: ProfileStateStore

    // MARK: - UI State

    var showSortSheet = false
    var showErrorAlert = false
    var errorMessage: String?

    private(set) var sortType: ProfileNFTSortType

    // MARK: - Computed Properties

    var nfts: [ProfileNFT] { store.myNFTs }

    var sortedNFTs: [ProfileNFT] {
        switch sortType {
        case .price:
            return nfts.sorted { $0.price < $1.price }
        case .rating:
            return nfts.sorted { $0.rating > $1.rating }
        case .name:
            return nfts.sorted { $0.name < $1.name }
        }
    }

    var isLoading: Bool {
        if case .loading = store.loadingState { return true }
        return false
    }

    var isEmpty: Bool { nfts.isEmpty && !isLoading }

    enum ViewState {
        case loading, loaded, empty, error(String)
    }

    var state: ViewState {
        switch store.loadingState {
        case .idle, .loading:
            return .loading
        case .refreshing, .loaded:
            // При рефреше показываем список со старыми данными — не скрываем
            return nfts.isEmpty ? .empty : .loaded
        case .error(let message):
            return nfts.isEmpty ? .error(message) : .loaded
        }
    }

    // MARK: - Init

    init(store: ProfileStateStore) {
        self.store = store
        self.sortType = ProfileNFTSortType.loadSaved()
    }

    // MARK: - Public Methods

    func loadNFTs() async {
        await store.loadAll()
        syncError()
    }

    func refresh() async {
        await store.refresh()
        syncError()
    }

    func retry() async {
        await store.loadAll(forceRefresh: true)
        syncError()
    }

    func changeSortType(_ newType: ProfileNFTSortType) {
        sortType = newType
        newType.save()
    }

    func toggleFavorite(nftID: String) async {
        let success = await store.toggleFavorite(nftID: nftID)
        if !success {
            errorMessage = MyNFTConstants.favoriteUpdateErrorMessage
            showErrorAlert = true
        }
    }

    // MARK: - Private

    private func syncError() {
        if case .error(let message) = store.loadingState {
            errorMessage = message
            showErrorAlert = true
        }
    }
}
