//
//  NftCollectionCell.swift
//  iOS-FakeNFT-Extended
//
//  Created by Владимир Брюковкин on 14.02.2026.
//

import Kingfisher
import SwiftUI

struct NftCollectionCell: View {

    // MARK: - Properties

    let nftId: String
    var nft: Nft?

    // MARK: - Body

    var body: some View {
        NavigationLink(destination: NftDetailBridgeView(nftId: nftId)) {
            cellContent
        }
        .buttonStyle(.plain)
    }

    // MARK: - Subviews

    private var cellContent: some View {
        VStack(alignment: .leading, spacing: 0) {
            imageBlock
            textBlock
        }
        .aspectRatio(108 / 192, contentMode: .fit)
    }

    private var imageBlock: some View {
        ZStack(alignment: .topTrailing) {
            nftImage
                .aspectRatio(1, contentMode: .fill)
                .clipped()

            Image("LikeNoActive")
                .frame(width: 40, height: 40)
        }
        .aspectRatio(1, contentMode: .fit)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    @ViewBuilder
    private var nftImage: some View {
        if let url = nft?.images.first {
            KFImage(url)
                .placeholder {
                    Rectangle()
                        .fill(Color.gray.opacity(0.2))
                }
                .onFailure { _ in }
                .resizable()
                .aspectRatio(contentMode: .fill)
        } else {
            Rectangle()
                .fill(Color.gray.opacity(0.2))
        }
    }

    private var textBlock: some View {
        VStack(alignment: .leading, spacing: 0) {
            ratingView
                .padding(.top, 8)

            nameAndCartRow
        }
    }

    private var nameAndCartRow: some View {
        HStack(alignment: .bottom, spacing: 0) {
            VStack(alignment: .leading, spacing: 4) {
                Text(nft?.name ?? "NFT")
                    .font(.bold17)
                    .foregroundStyle(.primary)
                    .lineLimit(1)

                Text(priceText)
                    .font(.medium10)
                    .tracking(-0.24)
                    .foregroundStyle(.primary)
            }
            Spacer(minLength: 0)
            Image("CartAdd")
                .frame(width: 40, height: 40)
        }
    }

    private var ratingView: some View {
        HStack(spacing: 2) {
            ForEach(0..<5, id: \.self) { index in
                Image(systemName: "star.fill")
                    .font(.system(size: 12))
                    .foregroundStyle(index < ratingValue ? Color.yellow : Color(uiColor: .appLightGray))
            }
        }
    }

    // MARK: - Helpers

    private var ratingValue: Int {
        guard let rating = nft?.rating else { return 0 }
        return min(5, max(0, rating))
    }

    private var priceText: String {
        guard let price = nft?.price else { return "0 ETH" }
        return String(format: "%.2f ETH", price)
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        NftCollectionCell(nftId: "7773e33c-ec15-4230-a102-92426a3a6d5a", nft: nil)
            .padding()
    }
}
