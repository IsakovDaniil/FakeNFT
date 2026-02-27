import SwiftUI

struct TabBarView: View {
    @State private var router = CartRouter()
    @Environment(CartViewModel.self) private var viewModel
    
    var body: some View {
        NavigationStack(path: $router.path) {
            TabView {
                CartScreen()
                    .tabItem {
                        Label {
                            Text("Tab.cart")
                        } icon: {
                            Image(.handbag)
                        }
                    }
                    .backgroundStyle(.background)
            }
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
        orderStorage: OrderStorageImpl()
    )
    let viewModel = CartViewModel(
        nftService: servicesAssembly.nftService,
        orderService: servicesAssembly.orderService
    )
    
    TabBarView()
        .environment(viewModel)
}
