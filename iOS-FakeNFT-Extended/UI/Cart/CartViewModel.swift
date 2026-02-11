//
//  CartViewModel.swift
//  iOS-FakeNFT-Extended
//
//  Created by Султан Ахметбек on 08.02.2026.
//

import SwiftUI

enum CartViewState: Equatable {
    case idle
    case loading
    case data
    case error(String)
}

@MainActor
@Observable
final class CartViewModel {
    private(set) var state: CartViewState = .idle
    private(set) var order: Order?
    private(set) var nfts: [Nft] = []
    private(set) var nftToDelete: Nft?
    private(set) var sortType: CartSortType? {
        didSet {
            Task {
                await loadOrder()
            }
        }
    }
    
    private let nftService: NftService
    private let orderService: OrderService
    
    init(nftService: NftService, orderService: OrderService) {
        self.nftService = nftService
        self.orderService = orderService
    }

    var itemsCount: Int? {
        nfts.count
    }
    
    var totalPriceText: String {
        let total = nfts.reduce(0.0) { $0 + Double($1.price) }
        return String(format: "%.2f", total)
            .replacingOccurrences(of: ".", with: ",")
    }

    func setNftToDelete(_ nft: Nft) {
        nftToDelete = nft
    }
    
    func closeDeleteView() {
        nftToDelete = nil
    }
    
    // MARK: - Public API
    
    func loadOrder() async {
        state = .loading
        do {
            let loadedOrder = try await orderService.load(sort: sortType?.rawValue)
            order = loadedOrder
            
            nfts.removeAll()
            await loadNfts()
            state = .data
        } catch {
            state = .error(error.localizedDescription)
        }
    }
    
    func loadNfts() async {
        guard let ids = order?.nfts else {
            return
        }

        var buffer = Array<Nft?>(repeating: nil, count: ids.count)
        nfts = []

        await withTaskGroup(of: (Int, Nft?).self) { group in
            for (index, id) in ids.enumerated() {
                group.addTask { [self] in
                    let nft = try? await self.nftService.loadNft(id: id)
                    return (index, nft)
                }
            }
            
            for await (index, nft) in group {
                if let nft {
                    buffer[index] = nft
                } else {
                    buffer[index] = nil
                }
                nfts = buffer.compactMap { $0 }
            }
        }
    }

    func addNFT(_ nft: Nft) async {
        guard !nfts.contains(where: { $0.id == nft.id }) else {
            return
        }

        state = .loading
        
        do {
            nfts.append(nft)
            let nftsIds = nfts.map { $0.id }
            let loadedOrder = try await orderService.save(nftsIds)
            order = loadedOrder

            await loadNfts()
            state = .data
        } catch {
            state = .error(error.localizedDescription)
        }
    }

    func removeNFT() async {
        guard let nft = nftToDelete, nfts.contains(where: { $0.id == nft.id }) else {
            return
        }
        
        state = .loading
        
        do {
            nfts.removeAll(where: { $0.id == nft.id })
            let nftsIds = nfts.map { $0.id }
            let loadedOrder = try await orderService.save(nftsIds)
            order = loadedOrder

            state = .data
        } catch {
            state = .error(error.localizedDescription)
        }
        
        closeDeleteView()
    }
    
    // MARK: - Sorting
    
    func setSort(_ type: CartSortType?) {
        if sortType == type { return }
        sortType = type
    }
}
