//
//  CartScreen.swift
//  iOS-FakeNFT-Extended
//
//  Created by Султан Ахметбек on 07.02.2026.
//

import SwiftUI

struct CartScreen: View {
    @State private var nfts: [Nft] = Nft.mockNFTs

    var body: some View {
        Group {
            if nfts.isEmpty {
                emptyStateView
            } else {
                cartListView
            }
        }
        .background(.appWhite)
    }
    
    private var cartListView: some View {
        ZStack {
            VStack(spacing: 0) {
                ScrollView {
                    LazyVStack {
                        ForEach(nfts, id: \.id) { nft in
                            CartCell(nft: nft)
                                .padding(16)
                        }
                    }
                    .padding(.top, 20)
                }
                
                bottomBar
            }
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image(systemName: "cart")
                .font(.system(size: 60))
                .foregroundStyle(.secondary)
            
            Text("Корзина пуста")
                .font(.bold17)
            
            Text("Добавьте NFT в корзину")
                .font(.regular15)
                .foregroundStyle(.secondary)
            
            Spacer()
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
        let total = nfts.reduce(0.0) { $0 + $1.price }
        return String(format: "%.2f", total)
            .replacingOccurrences(of: ".", with: ",")
    }
}

#Preview {
    CartScreen()
}
