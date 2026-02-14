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
            VStack(alignment: .leading, spacing: 0) {
                coverView
                    .ignoresSafeArea(edges: .top)

                collectionInfoBlock

                nftGridSection
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
                topTrailingRadius: 0,
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

    // MARK: - Блок информации о коллекции (задача 36)

    private var collectionInfoBlock: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(item.name)
                .font(.bold22)
                .foregroundStyle(.primary)
                .padding(.horizontal, 16)
                .padding(.top, 16)

            authorRow
                .padding(.top, 13)
                .padding(.horizontal, 16)

            Text(item.description)
                .font(.regular13)
                .lineSpacing(5)
                .tracking(-0.08)
                .multilineTextAlignment(.leading)
                .foregroundStyle(.primary)
                .padding(.horizontal, 16)
                .padding(.top, 8)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.bottom, 24)
    }

    // MARK: - Сетка NFT (задача 37)

    /// Сетка NFT коллекции: 3 колонки, отступы по макету (top 24pt, horizontal 16pt, spacing 9×8).
    /// Используем индекс как id, чтобы при дубликатах в nftIds отображалось по одной ячейке на каждый элемент.
    private var nftGridSection: some View {
        LazyVGrid(columns: nftGridColumns, spacing: CollectionDetailConstants.nftGridVerticalSpacing) {
            ForEach(Array(item.nftIds.enumerated()), id: \.offset) { _, nftId in
                NftCollectionCell(nftId: nftId)
            }
        }
        .padding(.top, CollectionDetailConstants.nftGridTopPadding)
        .padding(.horizontal, CollectionDetailConstants.nftGridHorizontalPadding)
    }

    private var nftGridColumns: [GridItem] {
        [
            GridItem(.flexible(), spacing: CollectionDetailConstants.nftGridHorizontalSpacing),
            GridItem(.flexible(), spacing: CollectionDetailConstants.nftGridHorizontalSpacing),
            GridItem(.flexible(), spacing: CollectionDetailConstants.nftGridHorizontalSpacing)
        ]
    }

    private var authorRow: some View {
        HStack(alignment: .firstTextBaseline, spacing: 0) {
            Text("Collection.author")
                .font(.regular13)
                .foregroundStyle(.primary)
            authorLinkOrText
        }
    }

    @ViewBuilder
    private var authorLinkOrText: some View {
        if !item.website.isEmpty, URL(string: item.website) != nil {
            NavigationLink(destination: WebViewScreen(urlString: item.website)) {
                Text(item.author)
                    .font(.regular15)
                    .foregroundStyle(Color("AppBlue"))
            }
        } else {
            Text(item.author)
                .font(.regular15)
                .foregroundStyle(Color("AppBlue"))
        }
    }
}

// MARK: - Constants

private enum CollectionDetailConstants {
    static let nftGridTopPadding: CGFloat = 24
    static let nftGridHorizontalPadding: CGFloat = 16
    static let nftGridHorizontalSpacing: CGFloat = 9
    static let nftGridVerticalSpacing: CGFloat = 8
}

// MARK: - Preview

#Preview {
    NavigationStack {
        CollectionDetailView(item: CollectionItem(
            id: "1",
            name: "Peach",
            imageURLs: [],
            nftCount: 11,
            nftIds: ["7773e33c-ec15-4230-a102-92426a3a6d5a", "id2"],
            localCoverImageName: "CataloguePeach",
            author: "John Doe",
            description: "Персиковый — как облака над закатным солнцем в океане. В этой коллекции совмещены трогательная нежность и живая игривость сказочных зефирных зверей.",
            website: "https://yandex.ru/legal/practicum_termsofuse",
        ))
    }
}
