//
//  CartScreen.swift
//  iOS-FakeNFT-Extended
//
//  Created by Султан Ахметбек on 07.02.2026.
//

import SwiftUI
import ProgressHUD

struct CartScreen: View {
    @Environment(CartViewModel.self) private var viewModel
    
    init() {
        ProgressHUD.colorHUD = .appLightGrayUniversal
        ProgressHUD.colorAnimation = .appBlackUniversal
        ProgressHUD.colorStatus = .appBlackUniversal
    }

    var body: some View {
        Group {
            if !viewModel.nfts.isEmpty {
                CartListView(viewModel: viewModel, nfts: viewModel.nfts)
            } else {
                CartEmptyView()
            }
        }
        .background(.appWhite)
        .task {
            await viewModel.loadOrder()
        }
        .onChange(of: viewModel.state) { _, newValue in
            switch newValue {
            case .loading:
                ProgressHUD.animate()
            case .data:
                ProgressHUD.dismiss()
            case .error(let message):
                ProgressHUD.error(message)
            case .idle:
                ProgressHUD.animate()
            }
        }
    }
}

#Preview {
    let services = ServicesAssembly(
        networkClient: DefaultNetworkClient(),
        nftStorage: NftStorageImpl(),
        orderStorage: OrderStorageImpl()
    )
    let vm = CartViewModel(
        nftService: services.nftService,
        orderService: services.orderService
    )
    
    CartScreen()
        .environment(vm)
}
