//
//  CatalogView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Владимир Брюковкин on 07.02.2026.
//

import SwiftUI

struct CatalogView: View {

    // MARK: - State

    @State private var viewModel = CatalogViewModel()
    @State private var selectedCollection: CollectionItem?
    @State private var showSortOptions = false
    @State private var showErrorAlert = false

    // MARK: - Body

    var body: some View {
        NavigationStack {
            ZStack {
                if viewModel.isLoading {
                    ProgressView()
                } else {
                    self.collectionList
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    self.sortButton
                }
            }
            .navigationDestination(item: self.$selectedCollection) { item in
                // TODO: Экран коллекции NFT (Модуль 2)
                Text(item.name)
            }
            .alert(
                Constants.errorMessage,
                isPresented: self.$showErrorAlert
            ) {
                Button(Constants.cancelTitle, role: .cancel) { }
                Button(Constants.retryTitle) {
                    viewModel.retry()
                }
            }
            .onChange(of: viewModel.showError) { _, new in
                self.showErrorAlert = new
            }
            .confirmationDialog(Constants.sortTitle, isPresented: self.$showSortOptions) {
                Button(Constants.sortByName) {
                    viewModel.setSortOrder(.byName)
                }
                Button(Constants.sortByNftCount) {
                    viewModel.setSortOrder(.byNftCount)
                }
                Button(Constants.sortClose, role: .cancel) { }
            }
            .onAppear {
                Task {
                    await viewModel.loadCollections()
                }
            }
        }
    }

    // MARK: - Subviews

    private var collectionList: some View {
        List(Array(viewModel.sortedCollections.enumerated()), id: \.element.id) { index, item in
            Button {
                self.selectedCollection = item
            } label: {
                CollectionRow(item: item)
            }
            .buttonStyle(.plain)
            .listRowInsets(EdgeInsets(
                top: index == 0 ? 20 : 4,
                leading: 16,
                bottom: 4,
                trailing: 16
            ))
            .listRowSeparator(.hidden)
        }
        .listStyle(.plain)
    }

    /// Кнопка сортировки в navigation bar
    private var sortButton: some View {
        Button {
            self.showSortOptions = true
        } label: {
            Image("Sort")
                .renderingMode(.template)
                .foregroundStyle(.primary)
        }
        .tint(.primary)
    }
}

// MARK: - Preview

#Preview {
    TabView {
        CatalogView()
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
