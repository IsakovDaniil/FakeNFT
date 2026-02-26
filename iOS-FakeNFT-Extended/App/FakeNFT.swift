import SwiftUI

@main
struct FakeNFT: App {

    private let servicesAssembly = ServicesAssembly(
        networkClient: DefaultNetworkClient(),
        nftStorage: NftStorageImpl(),
        profileStorage: ProfileStorage()
    )

    var body: some Scene {
        WindowGroup {
            ProfileView(
                viewModel: ProfileViewModel(
                    store: servicesAssembly.profileStore
                ),
                servicesAssembly: servicesAssembly
            )
        }
    }
}
