//
//  CartScreen.swift
//  iOS-FakeNFT-Extended
//
//  Created by Султан Ахметбек on 07.02.2026.
//

import SwiftUI
import ProgressHUD

struct CartScreen: View {
    @Environment(ServicesAssembly.self) var servicesAssembly
    @State private var viewModel: CartViewModel?

    var body: some View {
        Group {
            if let vm = viewModel, vm.nfts.isEmpty == false {
                CartListView(viewModel: vm, nfts: vm.nfts)
            } else {
                CartEmptyView()
            }
        }
        .background(.appWhite)
        .task {
            if viewModel == nil {
                let vm = CartViewModel(
                    nftService: servicesAssembly.nftService,
                    orderService: servicesAssembly.orderService
                )
                viewModel = vm
                await vm.loadOrder()
            }
        }
    }
}

#Preview {
    CartScreen()
        .environment(
            ServicesAssembly(
                networkClient: DefaultNetworkClient(),
                nftStorage: NftStorageImpl(),
                orderStorage: OrderStorageImpl()
            )
        )
}
