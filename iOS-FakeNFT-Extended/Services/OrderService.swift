import Foundation

protocol OrderService {
    func load() async throws -> Order
    func save(_ nfts: [String]) async throws -> Order
    func orderAndClear() async throws -> Order
    func loadCurrencies() async throws -> [Currency]
    func payment() async throws -> PaymentResult
}

@MainActor
final class OrderServiceImpl: OrderService {
    private let networkClient: NetworkClient
    private let storage: OrderStorage

    init(networkClient: NetworkClient, storage: OrderStorage) {
        self.storage = storage
        self.networkClient = networkClient
    }

    func load() async throws -> Order {
        let request = OrderRequest()
        let order: Order = try await networkClient.send(request: request)
        return order
    }
    
    func save(_ nfts: [String]) async throws -> Order {
        let request = OrderSaveRequest(nfts: nfts)
        let order: Order = try await networkClient.send(request: request)
        return order
    }
    
    func orderAndClear() async throws -> Order {
        let request = OrderSaveRequest(nfts: [])
        let order: Order = try await networkClient.send(request: request)
        return order
    }
    
    func loadCurrencies() async throws -> [Currency] {
        let request = CurrencyListRequest()
        let items: [Currency] = try await networkClient.send(request: request)
        return items
    }
    
    func payment() async throws -> PaymentResult {
        let request = PaymentRequest()
        let result: PaymentResult = try await networkClient.send(request: request)
        return result
    }
}
