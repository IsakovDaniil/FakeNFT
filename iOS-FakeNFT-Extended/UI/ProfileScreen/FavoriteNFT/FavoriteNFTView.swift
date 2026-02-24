//
//  FavoriteNFTView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Даниил on 07.02.2026.
//

import SwiftUI

struct FavoriteNFTView: View {

    // MARK: - Properties

    @State private var viewModel: FavoriteNFTViewModel

    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    // MARK: - Init

    init(viewModel: FavoriteNFTViewModel) {
        self._viewModel = State(initialValue: viewModel)
    }

    // MARK: - Body

    var body: some View {
        ZStack {
            Color.appWhite.ignoresSafeArea()
            content
        }
        .navigationTitle(FavoriteNFTConstants.navigationTitle)
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.loadFavorites()
        }
    }

    // MARK: - Content

    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .loading:
            ProgressView()
                .frame(maxWidth: .infinity, maxHeight: .infinity)

        case .loaded:
            grid

        case .empty:
            ProfileEmptyView(title: .favorite)

        case .error(let message):
            errorView(message: message)
        }
    }

    // MARK: - Subviews

    private var grid: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(viewModel.nfts) { nft in
                    ProfileFavoriteNFTRow(nft: nft) {
                        Task {
                            await viewModel.removeFromFavorites(nft)
                        }
                    }
                }
            }
            .padding(.init(top: 20, leading: 16, bottom: 20, trailing: 16))
        }
        .refreshable {
            await viewModel.loadFavorites()
        }
    }

    private func errorView(message: String) -> some View {
        VStack(spacing: 12) {
            Text(ProfileConstants.errorAlertTitle)
                .font(Font.bold17)
                .foregroundStyle(.appBlack)

            Text(message)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            Button(ProfileConstants.retryButton) {
                Task { await viewModel.loadFavorites() }
            }
            .buttonStyle(.borderedProminent)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
