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
    var isLiked: Bool = false
    var isInCart: Bool = false
    var onLikeTap: (() -> Void)?
    var onCartTap: (() -> Void)?

    // MARK: - Body

    var body: some View {
        NavigationLink(destination: NftDetailBridgeView(nftId: nftId)) {
            cellContentWithIconPlaceholders
        }
        .buttonStyle(.plain)
        .overlay(alignment: .topTrailing) {
            likeButton
        }
        .overlay(alignment: .bottomTrailing) {
            cartButton
        }
    }

    // MARK: - Subviews

    private var cellContentWithIconPlaceholders: some View {
        VStack(alignment: .leading, spacing: 0) {
            imageBlockWithLikePlaceholder
            textBlockWithCartPlaceholder
        }
        .aspectRatio(108 / 192, contentMode: .fit)
    }

    private var imageBlockWithLikePlaceholder: some View {
        ZStack(alignment: .topTrailing) {
            nftImage
                .aspectRatio(1, contentMode: .fill)
                .clipped()
            Color.clear
                .frame(width: 40, height: 40)
        }
        .aspectRatio(1, contentMode: .fit)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    @ViewBuilder
    private var nftImage: some View {
        if let url = nft?.imagesUrls.first {
            KFImage(url)
                .placeholder {
                    Rectangle()
                        .fill(Color.gray.opacity(0.2))
                }
                .resizable()
                .aspectRatio(contentMode: .fill)
        } else {
            Rectangle()
                .fill(Color.gray.opacity(0.2))
        }
    }

    private var textBlockWithCartPlaceholder: some View {
        VStack(alignment: .leading, spacing: 0) {
            ratingView
                .padding(.top, 8)
            nameAndCartRowWithPlaceholder
        }
    }

    private var nameAndCartRowWithPlaceholder: some View {
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
            Color.clear
                .frame(width: 40, height: 40)
        }
    }

    // MARK: - Кнопки поверх ячейки (overlay), чтобы тап не уходил в NavigationLink

    private var likeButton: some View {
        Button {
            onLikeTap?()
        } label: {
            Image(isLiked ? "LikeActive" : "LikeNoActive")
                .frame(width: 40, height: 40)
                .contentShape(Rectangle())
        }
        .buttonStyle(ScalePressButtonStyle())
    }

    private var cartButton: some View {
        Button {
            onCartTap?()
        } label: {
            Image(isInCart ? "CartDelete" : "CartAdd")
                .frame(width: 40, height: 40)
                .contentShape(Rectangle())
        }
        .buttonStyle(ScalePressButtonStyle())
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
        let rating = nft?.rating ?? 0
        return min(5, max(0, rating))
    }

    private var priceText: String {
        guard let nft = nft else { return "0 ETH" }
        return String(format: "%.2f ETH", Double(nft.price))
    }
}

// MARK: - ScalePressButtonStyle

private struct ScalePressButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.84 : 1.0)
            .animation(.easeInOut(duration: 0.15), value: configuration.isPressed)
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        NftCollectionCell(
            nftId: "7773e33c-ec15-4230-a102-92426a3a6d5a",
            nft: nil,
            isLiked: false,
            isInCart: false
        )
        .padding()
    }
}
