import Foundation

@Observable
@MainActor
final class ServicesAssembly {
    
    private let networkClient: NetworkClient
    private let nftStorage: NftStorage
    private let orderStorage: OrderStorage
    
    let nftService: NftService
    let profileService: ProfileServiceProtocol
    let profileMyNFTService: ProfileMyNFTServiceProtocol
    let profileStore: ProfileStateStore
    
    var orderService: OrderService {
        OrderServiceImpl(
            networkClient: networkClient,
            storage: orderStorage
        )
    }
    
    init(
        networkClient: NetworkClient,
        nftStorage: NftStorage,
        orderStorage: OrderStorage,
        profileStorage: ProfileStorageProtocol
    ) {
        self.networkClient = networkClient
        self.nftStorage = nftStorage
        self.orderStorage = orderStorage
        
        let profileSvc = ProfileService(networkClient: networkClient, storage: profileStorage)
        let nftSvc = ProfileMyNFTService(networkClient: networkClient)
        
        self.nftService = NftServiceImpl(networkClient: networkClient, storage: nftStorage)
        self.profileService = profileSvc
        self.profileMyNFTService = nftSvc
        self.profileStore = ProfileStateStore(
            profileService: profileSvc,
            nftService: nftSvc
        )
    }
}
