//
//  ProfileNFT.swift
//  iOS-FakeNFT-Extended
//
//  Created by Даниил on 17.02.2026.
//

import SwiftUI
import Kingfisher

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
    
    @ViewBuilder
    private var cardImage: some View {
        KFImage(URL(string: image))
            .placeholder {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: size.cardSize, height: size.cardSize)
                    .overlay {
                        ProgressView()
                    }
            }
            .resizable()
            .scaledToFill()
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .frame(width: size.cardSize, height: size.cardSize)
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
            image: "Lilo",
            size: .myNFT,
            isLiked: false,
            onLikeTap: { print("Liked!") }
        )
        
        ProfileNFTCard(
            image: "Pixi",
            size: .favorites,
            isLiked: true,
            onLikeTap: { print("Unliked!") }
        )
    }
}
