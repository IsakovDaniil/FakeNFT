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
        .navigationTitle(MyNFTConstants.navigationTitle)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                sortButton
            }
        }
        .confirmationDialog(
            MyNFTConstants.sortDialogTitle,
            isPresented: $viewModel.showSortSheet,
            titleVisibility: .visible
        ) {
            sortDialogButtons
        }
        .task {
            if case .idle = viewModel.state {
                await viewModel.loadNFTs()
            }
        }
        .onChange(of: viewModel.isLoading) { _, isLoading in
            if isLoading {
                ProgressHUD.animate()
            } else {
                ProgressHUD.dismiss()
            }
        }
        .alert(MyNFTConstants.errorAlertTitle, isPresented: $viewModel.showErrorAlert) {
            Button(MyNFTConstants.retryButtonTitle) {
                Task { await viewModel.retry() }
            }
            Button(MyNFTConstants.cancelButtonTitle, role: .cancel) {}
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
        case .idle, .loading:
            Color.clear
            
        case .loaded:
            listView
            
        case .empty:
            emptyView
            
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
                    Task {
                        await viewModel.toggleFavorite(nftID: nft.id)
                    }
                }
            )
            .listRowSeparator(.hidden)
            .listRowInsets(EdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 39))
        }
        .listStyle(.plain)
        .refreshable {
            await viewModel.refresh()
        }
    }
    
    private var emptyView: some View {
        Text(MyNFTConstants.emptyStateText)
            .font(Font.bold17)
            .foregroundStyle(.appBlack)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private var sortButton: some View {
        Button {
            viewModel.showSortSheet = true
        } label: {
            Image(.sort)
                .foregroundStyle(.appBlack)
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
        
        Button(MyNFTConstants.closeButtonTitle, role: .cancel) {}
    }
}

#Preview("Loaded") {
    let profile = UserProfile(
        name: "Test User",
        avatar: "",
        description: "",
        website: "",
        myNfts: ["e8c1f0b6-5caf-4f65-8e5b-12f4bcb29efb"],
        favoriteNfts: [],
        id: "1"
    )
    
    NavigationStack {
        MyNFTView(
            viewModel: MyNFTViewModel(
                service: ProfileMyNFTService(networkClient: DefaultNetworkClient()),
                profile: profile
            )
        )
    }
}
