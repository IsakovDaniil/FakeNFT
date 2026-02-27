import SwiftUI

struct TabBarView: View {
    @State private var router = CartRouter()
    @Environment(CartViewModel.self) private var viewModel
    private let servicesAssembly: ServicesAssembly

    init(servicesAssembly: ServicesAssembly) {
        self.servicesAssembly = servicesAssembly
    }

    var body: some View {
        TabView {
            // Profile tab — имеет свой NavigationStack внутри ProfileView
            ProfileView(
                viewModel: ProfileViewModel(store: servicesAssembly.profileStore),
                servicesAssembly: servicesAssembly
            )
            .tabItem {
                Label("Tab.profile", systemImage: "person.crop.circle")
            }

            // Cart tab — своя навигация через router
            NavigationStack(path: $router.path) {
                CartScreen()
                    .navigationDestination(for: CartRoute.self) { route in
                        switch route {
                        case .payment:
                            PaymentScreen()
                                .environment(viewModel)
                        case .paymentSuccess:
                            PaymentSuccessScreen()
                        }
                    }
            }
            .environment(router)
            .tabItem {
                Label("Tab.cart", systemImage: "bag.fill")
            }
        }
        .overlay {
            if viewModel.nftToDelete != nil {
                BlurView(style: .systemUltraThinMaterial)
                    .ignoresSafeArea()
                CartDeleteView(viewModel: viewModel)
            }
        }
    }
}

#Preview {
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

    TabBarView(servicesAssembly: servicesAssembly)
        .environment(viewModel)
}
