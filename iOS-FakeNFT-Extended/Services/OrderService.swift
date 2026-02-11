import Foundation

protocol OrderService {
    func load(sort: String?) async throws -> Order
    func save(_ nfts: [String]) async throws -> Order
    
}

@MainActor
final class OrderServiceImpl: OrderService {
    private let networkClient: NetworkClient
    private let storage: OrderStorage

    init(networkClient: NetworkClient, storage: OrderStorage) {
        self.storage = storage
        self.networkClient = networkClient
    }

    func load(sort: String?) async throws -> Order {
        let request = OrderRequest(sort: sort)
        let order: Order = try await networkClient.send(request: request)
        return order
    }
    
    func save(_ nfts: [String]) async throws -> Order {
        let request = OrderSaveRequest(nfts: nfts)
        let order: Order = try await networkClient.send(request: request)
        return order
    }
}
