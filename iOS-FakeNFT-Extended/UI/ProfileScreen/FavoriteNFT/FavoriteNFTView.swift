//
//  FavoriteNFTView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Даниил on 07.02.2026.
//

import SwiftUI

struct FavoriteNFTView: View {
    
    // MARK: - Properties
    
    let nfts: [ProfileNFT]
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    // MARK: - Body
    
    var body: some View {
        ZStack {
            Color.appWhite.ignoresSafeArea()
            grid
        }
        .navigationTitle("Избранные NFT")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    // MARK: - Subviews
    
    private var grid: some View {
        ScrollView {
            LazyVGrid(
                columns: columns,
                spacing: 20
            ) {
                ForEach(nfts.filter { $0.isFavorite }) { nft in
                    ProfileFavoriteNFTRow(nft: nft) {
                        
                    }
                }
            }
        }
        .padding(.init(top: 20, leading: 16, bottom: 20, trailing: 16))
        .refreshable {
            
        }
    }
    
    private var emptyView: some View {
        Text("У вас еще нет избранных NFT")
            .font(Font.bold17)
            .foregroundStyle(.appBlack)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
}

#Preview {
    NavigationStack {
        FavoriteNFTView(
            nfts: ProfileNFT.mockData
        )
    }
}
