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

    var likedIds: Set<String> = []
    var cartIds: Set<String> = []

    func isLiked(id: String) -> Bool {
        likedIds.contains(id)
    }

    func isInCart(id: String) -> Bool {
        cartIds.contains(id)
    }

    // MARK: - Private

    private let nftService: NftService?
    private let profileService: ProfileService?
    private let orderService: OrderService?

    // MARK: - Init

    init(
        item: CollectionItem,
        nftService: NftService? = nil,
        profileService: ProfileService? = nil,
        orderService: OrderService? = nil
    ) {
        self.item = item
        self.nftService = nftService
        self.profileService = profileService
        self.orderService = orderService
    }

    // MARK: - Public

    func loadNfts() async {
        await loadLikesAndCart()

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

    private func loadLikesAndCart() async {
        async let profileResult: Profile? = fetchProfileIfNeeded()
        async let orderResult: Order? = fetchOrderIfNeeded()
        let (profile, order) = await (profileResult, orderResult)
        likedIds = Set(profile?.likes ?? [])
        cartIds = Set(order?.nfts ?? [])
    }

    private func fetchProfileIfNeeded() async -> Profile? {
        guard let service = profileService else { return nil }
        return try? await service.fetchProfile()
    }

    private func fetchOrderIfNeeded() async -> Order? {
        guard let service = orderService else { return nil }
        return try? await service.fetchOrder()
    }

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
