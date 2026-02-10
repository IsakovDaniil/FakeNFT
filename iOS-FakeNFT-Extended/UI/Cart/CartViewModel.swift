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
            let loadedOrder = try await orderService.load()
            order = loadedOrder
            
            nfts.removeAll()
            await loadNfts()
            state = .data
        } catch {
            state = .error(error.localizedDescription)
        }
    }
    
    func loadNfts() async {
        var newNFTs: [Nft] = []
        
        guard let ids = order?.nfts else {
            return
        }
        
        await withTaskGroup(of: Nft?.self) { group in
            for id in ids {
                group.addTask { [self] in
                    try? await self.nftService.loadNft(id: id)
                }
            }
            
            for await nft in group {
                if let nft {
                    newNFTs.append(nft)
                }
            }
        }
        
        nfts.append(contentsOf: newNFTs)
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
}
