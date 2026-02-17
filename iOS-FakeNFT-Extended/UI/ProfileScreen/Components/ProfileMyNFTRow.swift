//
//  ProfileMyNFTRow.swift
//  iOS-FakeNFT-Extended
//
//  Created by Даниил on 17.02.2026.
//

import SwiftUI

struct ProfileMyNFTRow: View {
    
    // MARK: - Properties
    
    let image: String
    let name: String
    let author: String
    let price: String
    let rating: String
    @State var isLiked: Bool
    
    // MARK: - Body
    
    var body: some View {
        HStack(spacing: 20) {
            ProfileNFTCard(image: image, size: .myNFT, isLiked: isLiked)
            infoView
            
            Spacer()
            
            priceView
        }
    }
    
    // MARK: - Subviews
    
    private var infoView: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(name)
                .font(Font.bold17)
                .foregroundStyle(.appBlack)
            ProfileRating(rating: rating)
            Text(author)
                .font(Font.regular13)
                .foregroundStyle(.appBlack)
        }
    }
    
    private var priceView: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text("Цена")
                .font(Font.regular13)
                .foregroundStyle(.appBlack)
            Text("\(price) ETH")
                .font(Font.bold17)
                .foregroundStyle(.appBlack)
            
        }
    }
}

#Preview {
    VStack(spacing: 30) {
        ProfileMyNFTRow(image: "Lilo", name: "Lilo", author: "John Doe", price: "1,78", rating: "3", isLiked: true)
        ProfileMyNFTRow(image: "Pixi", name: "Spring", author: "John Doe", price: "1,78", rating: "3", isLiked: false)
        ProfileMyNFTRow(image: "April", name: "April", author: "John Doe", price: "1,78", rating: "3", isLiked: false)
    }
    .padding()
}
