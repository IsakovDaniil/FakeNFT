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
    
    private let service: ProfileMyNFTServiceProtocol
    
    // MARK: - State
    
    enum ViewState {
        case idle
        case loading
        case loaded([ProfileNFT])
        case empty
        case error(Error)
    }
    
    var state: ViewState = .idle
    
    // MARK: - Alert State
    
    var showErrorAlert = false
    var errorMessage: String?
    
    // MARK: - UI State
    
    var showSortSheet = false
    private(set) var sortType: ProfileNFTSortType
    
    // MARK: - Computed Properties
    
    var nfts: [ProfileNFT] {
        if case .loaded(let items) = state {
            return items
        }
        return []
    }
    
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
        if case .loading = state { return true }
        return false
    }
    
    var isEmpty: Bool {
        if case .empty = state { return true }
        return false
    }
    
    // MARK: - Init
    
    init(service: ProfileMyNFTServiceProtocol) {
        self.service = service
        self.sortType = ProfileNFTSortType.loadSaved()
    }
    
    // MARK: - Public Methods
    
    func loadNFTs() async {
        state = .loading
        
        do {
            let fetchedNFTs = try await service.fetchMyNFTs()
            
            if fetchedNFTs.isEmpty {
                state = .empty
            } else {
                state = .loaded(fetchedNFTs)
            }
        } catch {
            handleError(error)
        }
    }
    
    func refresh() async {
        do {
            let fetchedNFTs = try await service.fetchMyNFTs()
            
            if fetchedNFTs.isEmpty {
                state = .empty
            } else {
                state = .loaded(fetchedNFTs)
            }
        } catch {
            handleError(error)
        }
    }
    
    func changeSortType(_ newType: ProfileNFTSortType) {
        sortType = newType
        newType.save()
    }
    
    func toggleFavorite(nftID: String) async {
        guard case .loaded(var items) = state else { return }
        
        // Оптимистичное обновление UI
        if let index = items.firstIndex(where: { $0.id == nftID }) {
            items[index].isFavorite.toggle()
            state = .loaded(items)
        }
        
        // Отправка на сервер в фоне
        Task.detached { [weak self] in
            try? await self?.service.toggleFavorite(nftID: nftID)
        }
    }
    
    func retry() async {
        await loadNFTs()
    }
    
    // MARK: - Private Methods
    
    private func handleError(_ error: Error) {
        state = .error(error)
        errorMessage = error.localizedDescription
        showErrorAlert = true
    }
}
