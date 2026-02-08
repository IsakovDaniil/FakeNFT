import SwiftUI

@main
struct FakeNFT: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(ServicesAssembly(networkClient: DefaultNetworkClient(), nftStorage: NftStorageImpl(), orderStorage: OrderStorageImpl()))
        }
    }
}
