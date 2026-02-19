//
//  Currency.swift
//  iOS-FakeNFT-Extended
//
//  Created by Sultan Akhmetbek on 12.02.2026.
//

struct Currency: Decodable {
    let id: String
    let title: String
    let name: String
    let imageUrlString: String
    
    private enum CodingKeys: String, CodingKey {
        case id
        case title
        case name
        case imageUrlString = "image"
    }
}
