//
//  CartListView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Султан Ахметбек on 08.02.2026.
//

import SwiftUI

struct CartListView: View {
    let viewModel: CartViewModel
    let nfts: [Nft]
    
    var body: some View {
        ZStack {
            VStack {
                ScrollView {
                    LazyVStack {
                        ForEach(nfts, id: \.id) { nft in
                            CartCell(viewModel: viewModel, nft: nft)
                                .padding(16)
                                .contentShape(Rectangle())
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
    }
    
    private var bottomBar: some View {
        HStack(spacing: 24) {
            VStack(alignment: .leading) {
                Text("\(nfts.count) NFT")
                    .font(.regular15)
                
                Text("\(totalPriceText) ETH")
                    .font(.bold17)
                    .foregroundStyle(.appGreen)
            }
            
            CartButton(title: "К оплате") {}
        }
        .padding(16)
        .background(Color(.appLightGray).opacity(0.3))
        .clipShape(UnevenRoundedRectangle(topLeadingRadius: 12, topTrailingRadius: 12))
    }
    
    private var totalPriceText: String {
        let total = nfts.reduce(0.0) { $0 + Double($1.price) }
        return String(format: "%.2f", total)
            .replacingOccurrences(of: ".", with: ",")
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
    return CartListView(viewModel: vm, nfts: Nft.mockNFTs)
}
