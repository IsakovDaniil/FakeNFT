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
        VStack {
            ScrollView {
                LazyVStack {
                    ForEach(Array(nfts.enumerated()), id: \.offset) { _, nft in
                        CartCell(viewModel: viewModel, nft: nft)
                            .padding(16)
                            .contentShape(Rectangle())
                    }
                }
                .padding(.top, 20)
            }
            
            bottomBar
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
            
            CartButton(title: CartLn.cartPrice, height: 44) {}
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
    let viewModel = CartViewModel(
        nftService: services.nftService,
        orderService: services.orderService
    )
    
    CartListView(viewModel: viewModel, nfts: NftMock.mockNFTs)
}
