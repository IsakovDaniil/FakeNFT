//
//  CartViewModel.swift
//  iOS-FakeNFT-Extended
//
//  Created by Султан Ахметбек on 08.02.2026.
//

import SwiftUI
import Observation

enum CartViewState: Equatable {
    case idle
    case loading
    case data
    case checkoutSuccess
    case error(String)
}

@MainActor
@Observable
final class CartViewModel {
    private(set) var state: CartViewState = .idle
    private(set) var order: Order?
    private(set) var nfts: [Nft] = []
    private(set) var currencies: [Currency] = []
    private(set) var nftToDelete: Nft?
    private(set) var currencyToPay: Currency?
    var errorWrapper: ErrorWrapper?
    
    @ObservationIgnored
    @AppStorage(Constants.cartSortType)
    private var sortTypeRawValue: String?
    
    private(set) var sortType: CartSortType? {
        get {
            guard let raw = sortTypeRawValue else { return nil }
            return CartSortType(rawValue: raw)
        }
        set {
            let old = sortTypeRawValue
            sortTypeRawValue = newValue?.rawValue

            if old != sortTypeRawValue {
                sortNfts()
            }
        }
    }
    
    private let nftService: NftService
    private let orderService: OrderService
    
    init(nftService: NftService, orderService: OrderService) {
        self.nftService = nftService
        self.orderService = orderService
        
        _ = sortType
    }

    // MARK: - Computed properties
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
    
    // MARK: - Order
    
    func loadOrder() async {
        if state == .loading { return }
        state = .loading
        do {
            let loadedOrder = try await orderService.load()
            order = loadedOrder
            
            nfts.removeAll()
            await loadNfts()
            
            if sortType != nil { sortNfts() }
            
            state = .data
        } catch {
            state = .error(error.localizedDescription)
        }
    }
    
    func clearOrder() async {
        state = .loading
        
        do {
            let loadedOrder = try await orderService.orderAndClear()
            order = loadedOrder
            
            nfts.removeAll()
            await loadNfts()
            
            state = .data
        } catch {
            state = .error(error.localizedDescription)
        }
    }
    
    // MARK: - NFTs
    
    func loadNfts() async {
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
                    nfts.append(nft)
                }
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
        guard let type else { return }
        sortType = type
    }
    
    func sortNfts() {
        switch sortType {
        case .name:
            nfts = nfts.sorted {
                $0.name.localizedCompare($1.name) == .orderedAscending
            }
        case .rating:
            nfts = nfts.sorted { $0.rating > $1.rating }
        case .price:
            nfts = nfts.sorted { $0.price < $1.price }
        case .none:
            break
        }
    }

    // MARK: - Currencies
    
    func loadCurrencies() async {
        state = .loading
        
        do {
            let items = try await orderService.loadCurrencies()
            currencies = items
            state = .data
        } catch {
            state = .error(error.localizedDescription)
        }
    }
    
    func setCurrency(_ currency: Currency?) {
        self.currencyToPay = currency
    }
    
    func makePayment() async {
        guard let currencyToPay else { return }
        
        state = .loading
        
        do {
            let result = try await orderService.payment()
            if result.success {
                await clearOrder()
                state = .checkoutSuccess
            } else {
                state = .error(CartLn.paymentErrorText)
            }
        } catch {
            errorWrapper = ErrorWrapper(
                "Не удалось произвести оплату",
                retry: { [weak self] in
                    Task {
                        await self?.makePayment()
                    }
                }
            )

            state = .error(error.localizedDescription)
        }
    }
}
