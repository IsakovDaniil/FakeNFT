import SwiftUI

@main
struct FakeNFT: App {
    var body: some Scene {
        let servicesAssembly = ServicesAssembly(
            networkClient: DefaultNetworkClient(),
            nftStorage: NftStorageImpl(),
            orderStorage: OrderStorageImpl(),
            profileStorage: ProfileStorage()
        )
        let viewModel = CartViewModel(
            nftService: servicesAssembly.nftService,
            orderService: servicesAssembly.orderService
        )
        
        WindowGroup {
            ContentView()
                .environment(viewModel)
        }
    }
}
