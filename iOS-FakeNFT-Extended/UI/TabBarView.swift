import SwiftUI

struct TabBarView: View {
    @Environment(CartViewModel.self) private var viewModel
    
    var body: some View {
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
