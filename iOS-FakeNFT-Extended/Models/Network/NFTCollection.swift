//
//  NFTCollection.swift
//  iOS-FakeNFT-Extended
//
//  Created by Владимир Брюковкин on 10.02.2026.
//

import Foundation

/// Модель коллекции из API GET /api/v1/collections
struct NFTCollection: Decodable, Identifiable, Sendable {
    let id: String
    let createdAt: String
    let name: String
    let cover: String
    let nfts: [String]
    let description: String
    let author: String
    let website: String
}
