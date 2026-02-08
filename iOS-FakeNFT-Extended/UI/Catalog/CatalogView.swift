//
//  CatalogView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Владимир Брюковкин on 07.02.2026.
//

import SwiftUI

struct CatalogView: View {

    // MARK: - State

    @State private var isLoading = false
    @State private var showError = false
    @State private var selectedCollection: CollectionItem?

    // MARK: - Body

    var body: some View {
        NavigationStack {
            ZStack {
                if self.isLoading {
                    // TODO: заменить на общий экран загрузки (компонент из develop)
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
                isPresented: self.$showError
            ) {
                Button(Constants.cancelTitle, role: .cancel) { }
                Button(Constants.retryTitle) {
                    // TODO: Retry — будет подключено к ViewModel (#32)
                }
            }
        }
    }

    // MARK: - Subviews

    private var collectionList: some View {
        List(Array(MockData.collections.enumerated()), id: \.element.id) { index, item in
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
            // TODO: Action Sheet сортировки (#30)
        } label: {
            Image("Sort")
        }
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
}

// MARK: - Mock Data (из Assets для просмотра дизайна)

private enum MockData {
    static let collections: [CollectionItem] = [
        CollectionItem(
            id: "1",
            name: "Peach",
            imageURLs: [],
            nftCount: 11,
            localCoverImageName: "CataloguePeach"
        ),
        CollectionItem(
            id: "2",
            name: "Blue",
            imageURLs: [],
            nftCount: 6,
            localCoverImageName: "CatalogueBlue"
        ),
        CollectionItem(
            id: "3",
            name: "Brown",
            imageURLs: [],
            nftCount: 8,
            localCoverImageName: "CatalogueBrown"
        ),
        CollectionItem(
            id: "4",
            name: "Green",
            imageURLs: [],
            nftCount: 5,
            localCoverImageName: "CatalogueGreen"
        ),
        CollectionItem(
            id: "5",
            name: "Mix",
            imageURLs: [],
            nftCount: 12,
            localCoverImageName: "CataloguePeach"
        )
    ]
}
