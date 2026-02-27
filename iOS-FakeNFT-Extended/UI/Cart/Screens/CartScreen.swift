//
//  CartScreen.swift
//  iOS-FakeNFT-Extended
//
//  Created by Султан Ахметбек on 07.02.2026.
//

import SwiftUI
import ProgressHUD

struct CartScreen: View {
    @Environment(CartRouter.self) private var router
    @Environment(CartViewModel.self) private var viewModel
    @State private var isShowingSortSheet: Bool = false
    
    init() {
        ProgressHUD.colorHUD = .appLightGrayUniversal
        ProgressHUD.colorAnimation = .appBlackUniversal
        ProgressHUD.colorStatus = .appBlackUniversal
    }

    var body: some View {
        NavigationStack {
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
                case .data, .checkoutSuccess:
                    ProgressHUD.dismiss()
                case .error(let message):
                    ProgressHUD.error(message)
                case .idle:
                    ProgressHUD.animate()
                }
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
            case .data, .checkoutSuccess:
                ProgressHUD.dismiss()
            case .error(let message):
                ProgressHUD.error(message)
            case .idle:
                ProgressHUD.animate()
            }
        }
        .toolbar {
            if !viewModel.nfts.isEmpty {
                ToolbarItem {
                    Button {
                        isShowingSortSheet = true
                    } label: {
                        Image(.sort)
                            .foregroundStyle(.appBlack)
                    }
                }
            }
        }
        .confirmationDialog(
            CartLn.cartSortTitle,
            isPresented: $isShowingSortSheet,
            titleVisibility: .visible
        ) {
            ForEach(CartSortType.allCases, id: \.self) { type in
                Button {
                    viewModel.setSort(type)
                    isShowingSortSheet = false
                } label: {
                    Text(type.title)
                }
            }
            Button(CartLn.cartSortClose, role: .cancel) {
                isShowingSortSheet = false
            }
        }
    }
}

#Preview {
    let services = ServicesAssembly(
        networkClient: DefaultNetworkClient(),
        nftStorage: NftStorageImpl(),
        orderStorage: OrderStorageImpl(),
        profileStorage: ProfileStorage()
    )
    let viewModel = CartViewModel(
        nftService: services.nftService,
        orderService: services.orderService
    )
    
    CartScreen()
        .environment(viewModel)
}
