//
//  Currency.swift
//  iOS-FakeNFT-Extended
//
//  Created by Sultan Akhmetbek on 12.02.2026.
//

import Foundation

struct Currency: Decodable, Identifiable, Equatable {
    let id: String
    let title: String
    let name: String
    let imageUrl: URL
    
    private enum CodingKeys: String, CodingKey {
        case id
        case title
        case name
        case imageUrl = "image"
    }
}
