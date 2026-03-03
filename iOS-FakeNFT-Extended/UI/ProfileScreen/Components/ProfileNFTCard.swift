//
//  ProfileNFTCard.swift
//  iOS-FakeNFT-Extended
//
//  Created by Даниил on 17.02.2026.
//

import SwiftUI

struct ProfileNFTCard: View {

    // MARK: - Size

    enum NFTSize {
        case myNFT
        case favorites

        var cardSize: CGFloat {
            switch self {
            case .myNFT: 110
            case .favorites: 80
            }
        }

        var likePadding: CGFloat {
            switch self {
            case .myNFT: 10
            case .favorites: 5
            }
        }
    }

    // MARK: - Properties

    let image: String
    let size: NFTSize
    let isLiked: Bool
    var onLikeTap: (() -> Void)?

    // MARK: - Body

    var body: some View {
        ZStack(alignment: .topTrailing) {
            cardImage
            likeButton
        }
    }

    // MARK: - Subviews

    private var cardImage: some View {
        AsyncImage(url: URL(string: image)) { phase in
            switch phase {
            case .empty:
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.gray.opacity(0.2))
                    .overlay {
                        ProgressView()
                    }
            case .success(let image):
                image
                    .resizable()
                    .scaledToFill()
            case .failure:
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.gray.opacity(0.2))
                    .overlay {
                        Image(systemName: "photo")
                            .foregroundStyle(.secondary)
                    }
            @unknown default:
                EmptyView()
            }
        }
        .frame(width: size.cardSize, height: size.cardSize)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    private var likeButton: some View {
        Button {
            onLikeTap?()
        } label: {
            Image(.like)
                .foregroundStyle(isLiked ? .appRed : .appWhiteUniversal)
                .padding(size.likePadding)
        }
        .disabled(onLikeTap == nil)
    }
}

// MARK: - Preview

#Preview {
    VStack {
        ProfileNFTCard(
            image: "https://picsum.photos/200",
            size: .myNFT,
            isLiked: false,
            onLikeTap: { print("Liked!") }
        )

        ProfileNFTCard(
            image: "https://picsum.photos/200",
            size: .favorites,
            isLiked: true,
            onLikeTap: { print("Unliked!") }
        )
    }
}
