//
//  CatalogViewModel.swift
//  iOS-FakeNFT-Extended
//
//  Created by Владимир Брюковкин on 08.02.2026.
//

import Foundation
import Observation

// MARK: - Sort Order

enum CatalogSortOrder: String {
    case byName
    case byNftCount
}

// MARK: - View State

enum CatalogViewState: Equatable {
    case loading
    case loaded([CollectionItem])
    case error
}

// MARK: - CatalogViewModel

@MainActor
@Observable
final class CatalogViewModel {

    private(set) var state: CatalogViewState = .loading

    /// Текущий тип сортировки; сохраняется в UserDefaults.
    var sortOrder: CatalogSortOrder {
        didSet {
            UserDefaults.standard.set(sortOrder.rawValue, forKey: Self.sortOrderKey)
        }
    }

    /// Отсортированный список коллекций для отображения.
    var sortedCollections: [CollectionItem] {
        let list: [CollectionItem]
        switch state {
        case .loading, .error:
            list = []
        case .loaded(let items):
            list = items
        }
        switch sortOrder {
        case .byName:
            return list.sorted { $0.name.localizedStandardCompare($1.name) == .orderedAscending }
        case .byNftCount:
            return list.sorted { $0.nftCount > $1.nftCount }
        }
    }

    var isLoading: Bool {
        if case .loading = state { return true }
        return false
    }

    var showError: Bool {
        if case .error = state { return true }
        return false
    }

    private static let sortOrderKey = "catalogSortOrder"

    init() {
        let raw = UserDefaults.standard.string(forKey: Self.sortOrderKey)
        self.sortOrder = CatalogSortOrder(rawValue: raw ?? "") ?? .byNftCount
    }

    /// Загрузка коллекций. Пока использует моки; в #34 подставить вызов CollectionService.
    func loadCollections() async {
        state = .loading
        do {
            let items = try await Self.fetchCollectionsMock()
            state = .loaded(items)
        } catch {
            state = .error
        }
    }

    /// Повтор загрузки при ошибке.
    func retry() {
        Task {
            await loadCollections()
        }
    }

    func setSortOrder(_ order: CatalogSortOrder) {
        sortOrder = order
    }

    // MARK: - Mock (до появления CollectionService в #34)

    private static func fetchCollectionsMock() async throws -> [CollectionItem] {
        try await Task.sleep(nanoseconds: 300_000_000)
        return [
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
}
