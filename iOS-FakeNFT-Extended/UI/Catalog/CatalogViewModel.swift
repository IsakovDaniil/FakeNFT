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
            userDefaults.set(sortOrder.rawValue, forKey: Self.sortOrderKey)
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

    // MARK: - Private Properties

    private static let sortOrderKey = "catalogSortOrder"
    private let collectionService: CollectionService?
    private let userDefaults: UserDefaults

    init(collectionService: CollectionService? = nil, userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
        let raw = userDefaults.string(forKey: Self.sortOrderKey)
        self.sortOrder = CatalogSortOrder(rawValue: raw ?? "") ?? .byNftCount
        self.collectionService = collectionService
    }

    // MARK: - Public Methods

    /// Загрузка коллекций из API или мок (если сервис не передан, например для Preview).
    func loadCollections() async {
        state = .loading
        do {
            let items: [CollectionItem]
            if let service = collectionService {
                let apiCollections = try await service.fetchCollections()
                items = apiCollections.map { Self.mapToCollectionItem($0) }
            } else {
                items = try await Self.fetchCollectionsMock()
            }
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

    // MARK: - Private Methods

    private static func mapToCollectionItem(_ collection: NFTCollection) -> CollectionItem {
        let coverURL = URL(string: collection.cover)
        return CollectionItem(
            id: collection.id,
            name: collection.name,
            imageURLs: coverURL.map { [$0] } ?? [],
            nftCount: collection.nfts.count,
            localCoverImageName: nil
        )
    }

    // MARK: - Mock (для Preview и тестов)

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
