//
//  CartListView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Султан Ахметбек on 08.02.2026.
//

import SwiftUI
import ProgressHUD

struct CartListView: View {
    let viewModel: CartViewModel
    let nfts: [Nft]
    
    var body: some View {
        ZStack {
            VStack {
                ScrollView {
                    LazyVStack {
                        ForEach(Array(nfts.enumerated()), id: \.offset) { index, nft in
                            CartCell(viewModel: viewModel, nft: nft)
                                .padding(16)
                                .contentShape(Rectangle())
                                .onAppear {
                                    if index == nfts.count - 1 {
                                        Task { await viewModel.loadOrderNextPage() }
                                    }
                                }
                        }
                        
                        if viewModel.isLoadingPage {
                            ProgressView()
                                .padding(.vertical, 16)
                        }
                    }
                    .padding(.top, 20)
                }
                
                bottomBar
            }
            
            if viewModel.nftToDelete != nil {
                BlurView(style: .systemUltraThinMaterial)
                    .ignoresSafeArea()
                
                CartDeleteView(viewModel: viewModel)
            }
        }
        .refreshable {
            await viewModel.loadOrder()
        }
        
    }
    
    private var bottomBar: some View {
        HStack(spacing: 24) {
            VStack(alignment: .leading) {
                Text("\(nfts.count) NFT")
                    .font(.regular15)
                
                Text("\(viewModel.totalPriceText) ETH")
                    .font(.bold17)
                    .foregroundStyle(.appGreen)
            }
            
            CartButton(title: "К оплате") {}
        }
        .padding(16)
        .background(Color(.appLightGray).opacity(0.3))
        .clipShape(UnevenRoundedRectangle(topLeadingRadius: 12, topTrailingRadius: 12))
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
    
    CartListView(viewModel: vm, nfts: Nft.mockNFTs)
}
