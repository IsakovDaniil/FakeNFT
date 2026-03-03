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

    let item: CollectionItem

    // MARK: - Screen State

    private(set) var state: CollectionDetailState = .loading

    var nfts: [Nft] {
        switch state {
        case .loaded(let list):
            return list
        case .loading, .error:
            return cachedNfts
        }
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

    var likedIds: Set<String> = []
    var cartIds: Set<String> = []
    var likeUpdateError: Bool = false
    var cartUpdateError: Bool = false

    func isLiked(id: String) -> Bool {
        likedIds.contains(id)
    }

    func isInCart(id: String) -> Bool {
        cartIds.contains(id)
    }

    private var lastLikeToggleNftId: String?
    private var lastCartToggleNftId: String?
    private var cachedNfts: [Nft] = []

    // MARK: - Private Dependencies

    private let nftService: NftService?
    private let catalogProfileService: CatalogProfileService?
    private let orderService: OrderService?
    private let profileStore: ProfileStateStore?

    // MARK: - Init

    init(
        item: CollectionItem,
        nftService: NftService? = nil,
        catalogProfileService: CatalogProfileService? = nil,
        orderService: OrderService? = nil,
        profileStore: ProfileStateStore? = nil
    ) {
        self.item = item
        self.nftService = nftService
        self.catalogProfileService = catalogProfileService
        self.orderService = orderService
        self.profileStore = profileStore
    }

    // MARK: - Public

    func loadNfts() async {
        await loadLikesAndCart()

        let uniqueIds = orderedUniqueIds(item.nftIds)
        guard let service = nftService, !uniqueIds.isEmpty else {
            cachedNfts = []
            state = .loaded([])
            return
        }
        state = .loading
        do {
            let loaded = try await loadNftsParallel(ids: uniqueIds, service: service)
            let ordered = orderNfts(loaded, byIds: uniqueIds)
            cachedNfts = ordered
            state = .loaded(ordered)
        } catch {
            state = .error
        }
    }

    func retry() {
        Task {
            await loadNfts()
        }
    }

    func toggleLike(nftId: String) async {
        guard let service = catalogProfileService else { return }
        var newSet = likedIds
        if newSet.contains(nftId) {
            newSet.remove(nftId)
        } else {
            newSet.insert(nftId)
        }
        let ids = Array(newSet)
        do {
            try await service.updateLikes(ids: ids)
            likedIds = newSet
            await profileStore?.updateLikesFromCatalog(ids: ids)
        } catch {
            if ids.isEmpty {
                likedIds = newSet
                return
            }
            lastLikeToggleNftId = nftId
            likeUpdateError = true
        }
    }

    func clearLikeError() {
        likeUpdateError = false
        lastLikeToggleNftId = nil
    }

    func retryLikeToggle() async {
        guard let nftId = lastLikeToggleNftId else { return }
        lastLikeToggleNftId = nil
        await toggleLike(nftId: nftId)
        if !likeUpdateError {
            clearLikeError()
        }
    }

    func toggleCart(nftId: String) async {
        guard let service = orderService else { return }
        var newSet = cartIds
        if newSet.contains(nftId) {
            newSet.remove(nftId)
        } else {
            newSet.insert(nftId)
        }
        let ids = Array(newSet)
        do {
            try await service.updateOrder(nftIds: ids)
            cartIds = newSet
        } catch {
            if ids.isEmpty {
                cartIds = newSet
                return
            }
            lastCartToggleNftId = nftId
            cartUpdateError = true
        }
    }

    func clearCartError() {
        cartUpdateError = false
        lastCartToggleNftId = nil
    }

    func retryCartToggle() async {
        guard let nftId = lastCartToggleNftId else { return }
        lastCartToggleNftId = nil
        await toggleCart(nftId: nftId)
        if !cartUpdateError {
            clearCartError()
        }
    }

    // MARK: - Private

    private func loadLikesAndCart() async {
        async let profileResult: CatalogProfile? = fetchCatalogProfileIfNeeded()
        async let orderResult: Order? = fetchOrderIfNeeded()
        let (profile, order) = await (profileResult, orderResult)
        likedIds = Set(profile?.likes ?? [])
        cartIds = Set(order?.nfts ?? [])
    }

    private func fetchCatalogProfileIfNeeded() async -> CatalogProfile? {
        guard let service = catalogProfileService else { return nil }
        return try? await service.fetchProfile()
    }

    private func fetchOrderIfNeeded() async -> Order? {
        guard let service = orderService else { return nil }
        return try? await service.fetchOrder()
    }

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

    private func orderedUniqueIds(_ ids: [String]) -> [String] {
        var seen = Set<String>()
        return ids.filter { seen.insert($0).inserted }
    }
}
