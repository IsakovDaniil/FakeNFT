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
    @State private var showSortOptions = false
    @AppStorage("catalogSortOrder") private var sortOrder: String = CatalogSortOrder.byNftCount.rawValue

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
            .confirmationDialog(Constants.sortTitle, isPresented: self.$showSortOptions) {
                Button(Constants.sortByName) {
                    self.sortOrder = CatalogSortOrder.byName.rawValue
                }
                Button(Constants.sortByNftCount) {
                    self.sortOrder = CatalogSortOrder.byNftCount.rawValue
                }
                Button(Constants.sortClose, role: .cancel) { }
            }
        }
    }

    // MARK: - Subviews

    private var sortedCollections: [CollectionItem] {
        let list = MockData.collections
        guard let order = CatalogSortOrder(rawValue: sortOrder) else { return list }
        switch order {
        case .byName:
            return list.sorted { $0.name.localizedStandardCompare($1.name) == .orderedAscending }
        case .byNftCount:
            return list.sorted { $0.nftCount > $1.nftCount }
        }
    }

    private var collectionList: some View {
        List(Array(self.sortedCollections.enumerated()), id: \.element.id) { index, item in
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

// MARK: - Sort Order

private enum CatalogSortOrder: String {
    case byName
    case byNftCount
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
