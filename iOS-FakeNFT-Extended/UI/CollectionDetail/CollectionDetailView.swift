//
//  CollectionDetailView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Владимир Брюковкин on 12.02.2026.
//

import Kingfisher
import SwiftUI

// MARK: - View

struct CollectionDetailView: View {

    // MARK: - Environment

    @Environment(\.dismiss) private var dismiss

    // MARK: - Properties

    let item: CollectionItem

    // MARK: - Body

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                coverView
                    .ignoresSafeArea(edges: .top)
            }
        }
        .ignoresSafeArea(edges: .top)
        .navigationBarBackButtonHidden(true)
        .toolbarBackground(.hidden, for: .navigationBar)
        .toolbar(.hidden, for: .tabBar)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .foregroundStyle(Color("AppBlack"))
                }
            }
        }
    }

    // MARK: - Subviews

    /// Обложка коллекции. Высота по пропорции макета 375×310.
    /// Чтобы вернуть фиксированную высоту — заменить aspectRatio на .frame(height: 310).
    private var coverView: some View {
        coverImageContent
            .frame(maxWidth: .infinity)
            .aspectRatio(375 / 310, contentMode: .fit)
            .clipShape(UnevenRoundedRectangle(
                topLeadingRadius: 0,
                bottomLeadingRadius: 12,
                bottomTrailingRadius: 12,
                topTrailingRadius: 0
            ))
    }

    private var coverImageContent: some View {
        Group {
            if let localName = item.localCoverImageName {
                Image(localName)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } else if let url = item.imageURLs.first {
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
        .frame(maxWidth: .infinity)
        .clipped()
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        CollectionDetailView(item: CollectionItem(
            id: "1",
            name: "Peach",
            imageURLs: [],
            nftCount: 11,
            localCoverImageName: "CataloguePeach"
        ))
    }
}
