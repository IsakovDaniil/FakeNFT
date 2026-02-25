import Foundation

@Observable
@MainActor
final class ServicesAssembly {
    
    private let networkClient: NetworkClient
    private let nftStorage: NftStorage
    
    let nftService: NftService
    let profileService: ProfileServiceProtocol
    let profileMyNFTService: ProfileMyNFTServiceProtocol
    
    let profileStore: ProfileStateStore
    
    init(
        networkClient: NetworkClient,
        nftStorage: NftStorage,
        profileStorage: ProfileStorageProtocol
    ) {
        self.networkClient = networkClient
        self.nftStorage = nftStorage
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
