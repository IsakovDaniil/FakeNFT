//
//  CartListView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Султан Ахметбек on 08.02.2026.
//

import SwiftUI

struct CartListView: View {
    let nfts: [Nft]
    @State private var nftToDelete: Nft? = nil
    
    var body: some View {
        ZStack {
            VStack {
                ScrollView {
                    LazyVStack {
                        ForEach(nfts, id: \.id) {
                            CartCell(nft: $0, nftToDelete: $nftToDelete)
                                .padding(16)
                                .contentShape(Rectangle())
                        }
                    }
                    .padding(.top, 20)
                }
                
                bottomBar
            }
            
            if nftToDelete != nil {
                BlurView(style: .systemUltraThinMaterial)
                    .ignoresSafeArea()
                
                CartDeleteView(nft: $nftToDelete)
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
        let total = nfts.reduce(0.0) { $0 + $1.price }
        return String(format: "%.2f", total)
            .replacingOccurrences(of: ".", with: ",")
    }
}

#Preview {
    CartListView(nfts: Nft.mockNFTs)
}
