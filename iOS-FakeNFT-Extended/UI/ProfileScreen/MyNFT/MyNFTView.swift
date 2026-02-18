//
//  MyNFTView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Даниил on 07.02.2026.
//

import SwiftUI
import ProgressHUD

struct MyNFTView: View {
    
    // MARK: - Properties
    @Environment(\.dismiss) private var dismiss
    
    @State var showActionSheet: Bool = false

    private var nfts: [ProfileNFT] = [
        ProfileNFT(image: "Lilo", name: "Lilo", author: "John Doe", price: "1,78", rating: "3", isLiked: true),
        ProfileNFT(image: "Pixi", name: "Spring", author: "John Doe", price: "1,78", rating: "3", isLiked: true),
        ProfileNFT(image: "Pixi", name: "April", author: "John Doe", price: "1,78", rating: "3", isLiked: true)
    ]
    
    // MARK: - Body
    
    var body: some View {
        Group {
            if nfts.isEmpty {
                emptyView
            } else {
                listView
            }
        }
        .navigationTitle("Мои NFT")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    showActionSheet = true
                } label: {
                    Image(.sort)
                        .foregroundStyle(.appBlack)
                }
            }
        }
        .confirmationDialog("Соритровка", isPresented: $showActionSheet, titleVisibility: .visible) {
            Button("По цене") {
                
            }
            Button("По рейтингу") {
                
            }
            Button("По названию") {
                
            }
            Button("Закрыть", role: .destructive) {
                dismiss()
            }
        }
    }
    
    // MARK: - Subviews
    private var listView: some View {
        List(nfts) { nft in
            ProfileMyNFTRow(
                image: nft.image,
                name: nft.name,
                author: nft.author,
                price: nft.price,
                rating: nft.rating,
                isLiked: nft.isLiked
            )
            .listRowSeparator(.hidden)
            .listRowInsets(EdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 39))
        }
        .listStyle(.plain)
        .refreshable {
           await refreshNFTs()
        }
    }
    
    private var emptyView: some View {
        Text("У Вас еще нет NFT")
            .font(Font.bold17)
            .foregroundStyle(.appBlack)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private func refreshNFTs() async {
        try? await Task.sleep(nanoseconds: 1_000_000_000)
    }
}

#Preview {
    NavigationStack {
        MyNFTView()
    }
}
