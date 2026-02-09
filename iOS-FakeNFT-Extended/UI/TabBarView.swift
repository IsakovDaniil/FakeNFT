import SwiftUI

struct TabBarView: View {
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
    }
}

#Preview {
    let servicesAssembly = ServicesAssembly(
        networkClient: DefaultNetworkClient(),
        nftStorage: NftStorageImpl(),
        orderStorage: OrderStorageImpl()
    )
    let vm = CartViewModel(
        nftService: servicesAssembly.nftService,
        orderService: servicesAssembly.orderService
    )
    
    TabBarView()
        .environment(vm)
}
