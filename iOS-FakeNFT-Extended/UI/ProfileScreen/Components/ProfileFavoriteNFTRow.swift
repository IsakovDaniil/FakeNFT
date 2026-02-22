//
//  ProfileMyNFTRow.swift
//  iOS-FakeNFT-Extended
//
//  Created by Даниил on 17.02.2026.
//

import SwiftUI

struct ProfileFavoriteNFTRow: View {
    
    // MARK: - Properties
    
    let nft: ProfileNFT
    let onLikeTap: () -> Void
    
    // MARK: - Body
    
    var body: some View {
        HStack(spacing: 12) {
            ProfileNFTCard(
                image: nft.imageURL,
                size: .favorites,
                isLiked: nft.isFavorite,
                onLikeTap: onLikeTap
            )
            
            infoView
        }
    }
    
    // MARK: - Subviews
    
    private var infoView: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(nft.name)
                .font(Font.bold17)
                .foregroundStyle(.appBlack)
            
            ProfileRating(rating: nft.ratingString)
            
            Text("\(nft.priceFormatted) ETH")
                .font(Font.regular15)
                .foregroundStyle(.appBlack)
        }
    }
}

// MARK: - Preview

#Preview {
    VStack(spacing: 30) {
        ProfileFavoriteNFTRow(
            nft: ProfileNFT.mockData[0],
            onLikeTap: {}
        )
        
        ProfileFavoriteNFTRow(
            nft: ProfileNFT.mockData[1],
            onLikeTap: {}
        )
        
        ProfileFavoriteNFTRow(
            nft: ProfileNFT.mockData[2],
            onLikeTap: {}
        )
    }
    .padding()
}
