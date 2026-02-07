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
    @State private var selectedCollection: String?

    // MARK: - Body

    var body: some View {
        NavigationStack {
            ZStack {
                if self.isLoading {
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
            .navigationDestination(item: self.$selectedCollection) { collection in
                // TODO: Экран коллекции NFT (Модуль 2)
                Text(collection)
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
        List(Array(MockData.collections.enumerated()), id: \.element) { index, collection in
            Button {
                self.selectedCollection = collection
            } label: {
                // TODO: Заменить на CollectionRow (#29)
                Text(collection)
                    .font(.bold17)
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

// MARK: - Mock Data

private enum MockData {
    static let collections = [
        "Peach (11)",
        "Blue (6)",
        "Brown (8)",
    ]
}
