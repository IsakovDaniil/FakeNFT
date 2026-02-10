//
//  CartImageView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Султан Ахметбек on 07.02.2026.
//

import SwiftUI

struct CartImageView: View {
    let imageUrl: URL
    
    var body: some View {
        AsyncImage(url: imageUrl) { phase in
            switch phase {
            case .success(let image):
                image
                    .resizable()
                    .scaledToFill()
            case .failure:
                Color(.tertiarySystemFill)
                    .overlay(
                        Image(systemName: "photo")
                            .foregroundStyle(.secondary)
                    )
            case .empty:
                Color(.tertiarySystemFill)
            @unknown default:
                Color(.tertiarySystemFill)
            }
        }
    }
}

#Preview {
    CartImageView(imageUrl: Nft.mockNFT.imagesUrls.first!)
}
