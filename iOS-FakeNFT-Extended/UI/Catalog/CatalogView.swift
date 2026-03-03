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
                    catalogProfileService: assembly.catalogProfileService,
                    orderService: assembly.orderService,
                    profileStore: assembly.profileStore
                )
            }
            .alert(
                CatalogConstants.errorMessage,
                isPresented: $showErrorAlert
            ) {
                Button(CatalogConstants.cancelTitle, role: .cancel) { }
                Button(CatalogConstants.retryTitle) {
                    viewModel.retry()
                }
            }
            .onChange(of: viewModel.showError) { _, new in
                showErrorAlert = new
            }
            .confirmationDialog(CatalogConstants.sortTitle, isPresented: $showSortOptions, titleVisibility: .visible) {
                Button(CatalogConstants.sortByName) {
                    viewModel.setSortOrder(.byName)
                }
                Button(CatalogConstants.sortByNftCount) {
                    viewModel.setSortOrder(.byNftCount)
                }
                Button(CatalogConstants.sortClose, role: .cancel) { }
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
    let networkClient = DefaultNetworkClient()
    let nftStorage = NftStorageImpl()
    let orderStorage = OrderStorageImpl()
    let profileStorage = ProfileStorage()
    let assembly = ServicesAssembly(
        networkClient: networkClient,
        nftStorage: nftStorage,
        orderStorage: orderStorage,
        profileStorage: profileStorage
    )
    return TabView {
        CatalogView(assembly: assembly)
        .tabItem {
            Label(
                NSLocalizedString("Tab.catalog", comment: ""),
                systemImage: "square.stack.3d.up.fill"
            )
        }
    }
}

// MARK: - Constants

private enum CatalogConstants {
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
