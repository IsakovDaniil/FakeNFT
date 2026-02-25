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

    @State private var viewModel: MyNFTViewModel

    // MARK: - Init

    init(viewModel: MyNFTViewModel) {
        self._viewModel = State(initialValue: viewModel)
    }

    // MARK: - Body

    var body: some View {
        ZStack {
            Color.appWhite.ignoresSafeArea()
            contentView
        }
        .navigationTitle(ProfileConstants.MyNFT.navigationTitle)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                sortButton
            }
        }
        .confirmationDialog(
            ProfileConstants.MyNFT.sortDialogTitle,
            isPresented: $viewModel.showSortSheet,
            titleVisibility: .visible
        ) {
            sortDialogButtons
        }
        .task {
            await viewModel.loadNFTs()
        }
        .onChange(of: viewModel.isLoading) { _, isLoading in
            isLoading ? ProgressHUD.animate() : ProgressHUD.dismiss()
        }
        .alert(ProfileConstants.errorAlertTitle, isPresented: $viewModel.showErrorAlert) {
            Button(ProfileConstants.MyNFT.retryButtonTitle) {
                Task { await viewModel.retry() }
            }
            Button(ProfileConstants.MyNFT.cancelButtonTitle, role: .cancel) {}
        } message: {
            if let message = viewModel.errorMessage {
                Text(message)
            }
        }
    }

    // MARK: - Content View

    @ViewBuilder
    private var contentView: some View {
        switch viewModel.state {
        case .loading:
            Color.clear

        case .loaded:
            listView

        case .empty:
            ProfileEmptyView(screen: .myNFT)

        case .error:
            Color.clear
        }
    }

    // MARK: - Subviews

    private var listView: some View {
        List(viewModel.sortedNFTs) { nft in
            ProfileMyNFTRow(
                nft: nft,
                onLikeTap: {
                    Task { await viewModel.toggleFavorite(nftID: nft.id) }
                }
            )
            .listRowSeparator(.hidden)
            .listRowInsets(EdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 39))
            .listRowBackground(Color.appWhite)
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
        .background(.appWhite)
        .refreshable {
            await viewModel.refresh()
        }
    }

    private var sortButton: some View {
        Button {
            viewModel.showSortSheet = true
        } label: {
            Image(.sort).foregroundStyle(.appBlack)
        }
        .disabled(viewModel.isEmpty || viewModel.isLoading)
    }

    @ViewBuilder
    private var sortDialogButtons: some View {
        ForEach(ProfileNFTSortType.allCases, id: \.self) { sortType in
            Button(sortType.title) {
                viewModel.changeSortType(sortType)
            }
        }
        Button(ProfileConstants.MyNFT.closeButtonTitle, role: .cancel) {}
    }
}
