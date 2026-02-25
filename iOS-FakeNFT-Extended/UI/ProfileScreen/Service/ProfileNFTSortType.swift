//
//  ProfileNFTSortType.swift
//  iOS-FakeNFT-Extended
//
//  Created by Даниил on 18.02.2026.
//

import Foundation

enum ProfileNFTSortType: String, CaseIterable {
    case price = "По цене"
    case rating = "По рейтингу"
    case name = "По названию"
    
    var title: String {
        rawValue
    }
    
    // MARK: - UserDefaults
    
    private static let sortTypeKey = "profileNFTSortType"
    
    static func loadSaved() -> ProfileNFTSortType {
        guard let rawValue = UserDefaults.standard.string(forKey: sortTypeKey),
              let sortType = ProfileNFTSortType(rawValue: rawValue) else {
            return .price
        }
        return sortType
    }
    
    func save() {
        UserDefaults.standard.set(rawValue, forKey: ProfileNFTSortType.sortTypeKey)
    }
}
