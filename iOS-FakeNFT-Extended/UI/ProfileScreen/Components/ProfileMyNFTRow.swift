//
//  ProfileMyNFTRow.swift
//  iOS-FakeNFT-Extended
//
//  Created by Даниил on 17.02.2026.
//

import SwiftUI

struct ProfileMyNFTRow: View {
    
    // MARK: - Properties
    
    let nft: ProfileNFT
    let onLikeTap: () -> Void
    
    // MARK: - Body
    
    var body: some View {
        ZStack {
            Color.appWhite.ignoresSafeArea()
            
            HStack(spacing: 20) {
                ProfileNFTCard(
                    image: nft.imageURL,
                    size: .myNFT,
                    isLiked: nft.isFavorite,
                    onLikeTap: onLikeTap
                )
                
                infoView
                Spacer()
                priceView
            }
        }
    }
    
    // MARK: - Subviews
    
    private var infoView: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(nft.name)
                .font(Font.bold17)
                .foregroundStyle(.appBlack)
            
            ProfileRating(rating: nft.ratingString)
            
            Text(nft.author ?? "Неизвестный автор")
                .font(Font.regular13)
                .foregroundStyle(.appBlack)
        }
    }
    
    private var priceView: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text("Цена")
                .font(Font.regular13)
                .foregroundStyle(.appBlack)
            
            Text("\(nft.priceFormatted) ETH")
                .font(Font.bold17)
                .foregroundStyle(.appBlack)
                .lineLimit(1)
        }
    }
}

// MARK: - Preview

#Preview {
    VStack(spacing: 30) {
        ProfileMyNFTRow(
            nft: ProfileNFT.mockData[0],
            onLikeTap: {}
        )
        
        ProfileMyNFTRow(
            nft: ProfileNFT.mockData[1],
            onLikeTap: {}
        )
        
        ProfileMyNFTRow(
            nft: ProfileNFT.mockData[2],
            onLikeTap: {}
        )
    }
    .padding()
}
