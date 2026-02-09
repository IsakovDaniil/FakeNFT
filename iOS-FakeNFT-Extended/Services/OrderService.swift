import Foundation

protocol OrderService {
    func load(page: Int) async throws -> Order
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

    func load(page: Int) async throws -> Order {
//        if let order = await storage.getOrder() {
//            return order
//        }

        let request = OrderRequest(page: page)
        let order: Order = try await networkClient.send(request: request)
        await storage.saveOrder(order)
        return order
    }
    
    func save(_ nfts: [String]) async throws -> Order {
        let request = OrderSaveRequest(nfts: nfts)
        let order: Order = try await networkClient.send(request: request)
        return order
    }
}
