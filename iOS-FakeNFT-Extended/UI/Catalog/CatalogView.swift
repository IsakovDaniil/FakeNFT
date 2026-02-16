//
//  CatalogView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Владимир Брюковкин on 07.02.2026.
//

import SwiftUI

struct CatalogView: View {

    // MARK: - State

    @State private var viewModel: CatalogViewModel
    @State private var selectedCollection: CollectionItem?
    @State private var showSortOptions = false
    @State private var showErrorAlert = false

    // MARK: - Properties

    private let assembly: ServicesAssembly

    init(assembly: ServicesAssembly) {
        self.assembly = assembly
        _viewModel = State(initialValue: CatalogViewModel(collectionService: assembly.collectionService))
    }

    // MARK: - Body

    var body: some View {
        NavigationStack {
            ZStack {
                if viewModel.isLoading {
                    ProgressView()
                } else {
                    collectionList
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    sortButton
                }
            }
            .navigationDestination(item: $selectedCollection) { collection in
                CollectionDetailView(
                    item: collection,
                    nftService: assembly.nftService,
                    profileService: assembly.profileService,
                    orderService: assembly.orderService
                )
            }
            .alert(
                Constants.errorMessage,
                isPresented: $showErrorAlert
            ) {
                Button(Constants.cancelTitle, role: .cancel) { }
                Button(Constants.retryTitle) {
                    viewModel.retry()
                }
            }
            .onChange(of: viewModel.showError) { _, new in
                showErrorAlert = new
            }
            .confirmationDialog(Constants.sortTitle, isPresented: $showSortOptions, titleVisibility: .visible) {
                Button(Constants.sortByName) {
                    viewModel.setSortOrder(.byName)
                }
                Button(Constants.sortByNftCount) {
                    viewModel.setSortOrder(.byNftCount)
                }
                Button(Constants.sortClose, role: .cancel) { }
            }
            .task {
                await viewModel.loadCollections()
            }
        }
    }

    // MARK: - Subviews

    private var collectionList: some View {
        ScrollView {
            LazyVStack(spacing: 8) {
                ForEach(viewModel.sortedCollections) { item in
                    Button {
                        selectedCollection = item
                    } label: {
                        CollectionRow(item: item)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 20)
            .padding(.bottom, 8)
        }
    }

    private var sortButton: some View {
        Button {
            showSortOptions = true
        } label: {
            Image(.sort)
                .renderingMode(.template)
                .foregroundStyle(.primary)
        }
        .tint(.primary)
    }
}

// MARK: - Preview

#Preview {
    TabView {
        CatalogView(assembly: ServicesAssembly(
            networkClient: DefaultNetworkClient(),
            nftStorage: NftStorageImpl()
        ))
        .tabItem {
            Label(
                NSLocalizedString("Tab.catalog", comment: ""),
                systemImage: "square.stack.3d.up.fill"
            )
        }
    }
}

// MARK: - Constants

private enum Constants {
    static let errorMessage = NSLocalizedString(
        "Catalog.error.message", comment: ""
    )
    static let cancelTitle = NSLocalizedString(
        "Catalog.alert.cancel", comment: ""
    )
    static let retryTitle = NSLocalizedString(
        "Error.repeat", comment: ""
    )
    static let sortTitle = NSLocalizedString(
        "Catalog.sort.title", comment: ""
    )
    static let sortByName = NSLocalizedString(
        "Catalog.sort.byName", comment: ""
    )
    static let sortByNftCount = NSLocalizedString(
        "Catalog.sort.byNftCount", comment: ""
    )
    static let sortClose = NSLocalizedString(
        "Catalog.sort.close", comment: ""
    )
}
