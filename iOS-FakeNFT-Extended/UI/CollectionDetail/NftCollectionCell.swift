//
//  NftCollectionCell.swift
//  iOS-FakeNFT-Extended
//
//  Created by Владимир Брюковкин on 14.02.2026.
//

import SwiftUI

/// Ячейка NFT в сетке коллекции. Пропорция по макету: 108×192 (ширина вычисляется из сетки).
struct NftCollectionCell: View {

    let nftId: String

    var body: some View {
        NavigationLink(destination: NftDetailBridgeView(nftId: nftId)) {
            cellContent
        }
        .buttonStyle(.plain)
    }

    private var cellContent: some View {
        Rectangle()
            .fill(Color.gray.opacity(0.2))
            .aspectRatio(108 / 192, contentMode: .fit)
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        NftCollectionCell(nftId: "7773e33c-ec15-4230-a102-92426a3a6d5a")
            .padding()
    }
}
