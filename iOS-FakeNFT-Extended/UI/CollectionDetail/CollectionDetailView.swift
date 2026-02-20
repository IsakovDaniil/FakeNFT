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

    // MARK: - State

    @State private var viewModel: CollectionDetailViewModel
    @State private var showErrorAlert = false
    @State private var showLikeErrorAlert = false
    @State private var showCartErrorAlert = false

    // MARK: - Properties

    private var item: CollectionItem { viewModel.item }

    // MARK: - Init

    init(
        item: CollectionItem,
        nftService: NftService? = nil,
        catalogProfileService: CatalogProfileService? = nil,
        orderService: OrderService? = nil
    ) {
        _viewModel = State(initialValue: CollectionDetailViewModel(
            item: item,
            nftService: nftService,
            catalogProfileService: catalogProfileService,
            orderService: orderService
        ))
    }

    // MARK: - Body

    var body: some View {
        ZStack {
            if viewModel.isLoading {
                ProgressView()
            } else {
                scrollContent
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
                        .foregroundStyle(Color(uiColor: .appBlack))
                }
            }
        }
        .alert(Constants.errorMessage, isPresented: $showErrorAlert) {
            Button(Constants.cancelTitle, role: .cancel) { }
            Button(Constants.retryTitle) {
                viewModel.retry()
            }
        }
        .alert(Constants.errorMessage, isPresented: $showLikeErrorAlert) {
            Button(Constants.cancelTitle, role: .cancel) {
                viewModel.clearLikeError()
            }
            Button(Constants.retryTitle) {
                Task {
                    await viewModel.retryLikeToggle()
                }
            }
        }
        .alert(Constants.errorMessage, isPresented: $showCartErrorAlert) {
            Button(Constants.cancelTitle, role: .cancel) {
                viewModel.clearCartError()
            }
            Button(Constants.retryTitle) {
                Task {
                    await viewModel.retryCartToggle()
                }
            }
        }
        .onChange(of: viewModel.isError) { _, new in
            showErrorAlert = new
        }
        .onChange(of: viewModel.likeUpdateError) { _, new in
            showLikeErrorAlert = new
        }
        .onChange(of: viewModel.cartUpdateError) { _, new in
            showCartErrorAlert = new
        }
        .task {
            await viewModel.loadNfts()
        }
    }

    private var scrollContent: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                coverView
                    .ignoresSafeArea(edges: .top)

                collectionInfoBlock

                nftGridSection
            }
        }
        .ignoresSafeArea(edges: .top)
    }

    // MARK: - Subviews

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

    private var nftGridSection: some View {
        LazyVGrid(columns: nftGridColumns, spacing: 8) {
            ForEach(viewModel.nfts, id: \.id) { nft in
                NftCollectionCell(
                    nftId: nft.id,
                    nft: nft,
                    isLiked: viewModel.isLiked(id: nft.id),
                    isInCart: viewModel.isInCart(id: nft.id),
                    onLikeTap: {
                        Task {
                            await viewModel.toggleLike(nftId: nft.id)
                        }
                    },
                    onCartTap: {
                        Task {
                            await viewModel.toggleCart(nftId: nft.id)
                        }
                    }
                )
            }
        }
        .padding(.horizontal, 16)
    }

    private var authorRow: some View {
        HStack(alignment: .firstTextBaseline, spacing: 0) {
            Text("Collection.author")
                .font(.regular13)
                .foregroundStyle(.primary)
            authorLinkOrText
        }
    }

    /// Имя автора — ссылка на сайт в WKWebView. URL из API, при ошибке — fallback.
    @ViewBuilder
    private var authorLinkOrText: some View {
        if !item.website.isEmpty, URL(string: item.website) != nil {
            NavigationLink(
                destination: AuthorWebsiteScreen(
                    urlString: item.website,
                    fallbackUrlString: Constants.fallbackAuthorWebsiteURL
                )
            ) {
                Text(item.author)
                    .font(.regular15)
                    .foregroundStyle(Color(uiColor: .appBlue))
            }
        } else {
            Text(item.author)
                .font(.regular15)
                .foregroundStyle(Color(uiColor: .appBlue))
        }
    }

    // MARK: - Helpers

    private var nftGridColumns: [GridItem] {
        [
            GridItem(.flexible(), spacing: 9),
            GridItem(.flexible(), spacing: 9),
            GridItem(.flexible(), spacing: 9)
        ]
    }
}

// MARK: - Constants

private enum Constants {
    /// Fallback при ошибке загрузки сайта автора (mock-API возвращает несуществующие домены)
    static let fallbackAuthorWebsiteURL = "https://practicum.yandex.ru/ios-developer/"
    static let errorMessage = NSLocalizedString("Catalog.error.message", comment: "")
    static let cancelTitle = NSLocalizedString("Catalog.alert.cancel", comment: "")
    static let retryTitle = NSLocalizedString("Error.repeat", comment: "")
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
