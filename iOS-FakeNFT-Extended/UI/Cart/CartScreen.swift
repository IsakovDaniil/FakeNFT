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
                CartEmptyView()
            } else {
                CartListView(nfts: nfts)
            }
        }
        .background(.appWhite)
    }
}

#Preview {
    CartScreen()
}
