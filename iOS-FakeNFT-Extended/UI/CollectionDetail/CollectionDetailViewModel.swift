//
//  CollectionDetailViewModel.swift
//  iOS-FakeNFT-Extended
//
//  Created by Владимир Брюковкин on 15.02.2026.
//

import Foundation
import Observation

// MARK: - State

enum CollectionDetailState {
    case loading
    case loaded([Nft])
    case error
}

// MARK: - CollectionDetailViewModel

@MainActor
@Observable
final class CollectionDetailViewModel {

    // MARK: - Collection Data

    /// Данные коллекции (название, описание, автор, обложка) — из переданного item.
    let item: CollectionItem

    // MARK: - Screen State

    private(set) var state: CollectionDetailState = .loading

    /// Список NFT коллекции (при state == .loaded).
    var nfts: [Nft] {
        if case .loaded(let list) = state { return list }
        return []
    }

    var isLoading: Bool {
        if case .loading = state { return true }
        return false
    }

    var isError: Bool {
        if case .error = state { return true }
        return false
    }

    // MARK: - Likes & Cart

    /// ID NFT в избранном.
    var likedIds: Set<String> = []
    /// ID NFT в корзине.
    var cartIds: Set<String> = []

    func isLiked(id: String) -> Bool {
        likedIds.contains(id)
    }

    func isInCart(id: String) -> Bool {
        cartIds.contains(id)
    }

    // MARK: - Private

    private let nftService: NftService?

    // MARK: - Init

    init(item: CollectionItem, nftService: NftService? = nil) {
        self.item = item
        self.nftService = nftService
    }

    // MARK: - Public

    /// Загрузить NFT коллекции по item.nftIds (async/await, параллельно через withTaskGroup).
    func loadNfts() async {
        guard let service = nftService, !item.nftIds.isEmpty else {
            state = .loaded([])
            return
        }
        state = .loading
        do {
            let loaded = try await loadNftsParallel(ids: item.nftIds, service: service)
            let ordered = orderNfts(loaded, byIds: item.nftIds)
            state = .loaded(ordered)
        } catch {
            state = .error
        }
    }

    /// Повтор загрузки при ошибке.
    func retry() {
        Task {
            await loadNfts()
        }
    }

    // MARK: - Private

    private func loadNftsParallel(ids: [String], service: NftService) async throws -> [Nft] {
        try await withThrowingTaskGroup(of: Nft.self, returning: [Nft].self) { group in
            for id in ids {
                group.addTask {
                    try await service.loadNft(id: id)
                }
            }
            var result: [Nft] = []
            for try await nft in group {
                result.append(nft)
            }
            return result
        }
    }

    private func orderNfts(_ nfts: [Nft], byIds ids: [String]) -> [Nft] {
        let byId = Dictionary(nfts.map { ($0.id, $0) }, uniquingKeysWith: { first, _ in first })
        return ids.compactMap { byId[$0] }
    }
}
