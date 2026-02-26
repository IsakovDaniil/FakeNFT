//
//  ProfileNFT.swift
//  iOS-FakeNFT-Extended
//
//  Created by Даниил on 17.02.2026.
//

import Foundation

struct ProfileNFT: Identifiable, Codable {
    let id: String
    let images: [String]
    let name: String
    let author: String?
    let price: Double
    let rating: Int
    var isFavorite: Bool = false
    
    var imageURL: String {
        images.first ?? ""
    }
    
    var priceFormatted: String {
        String(format: "%.2f", price)
    }
    
    var ratingString: String {
        String(rating)
    }
    
    enum CodingKeys: String, CodingKey {
        case id, images, name, author, price, rating
    }
}

// MARK: - Mock Data

extension ProfileNFT {
    static let mockData: [ProfileNFT] = [
        ProfileNFT(
            id: "1",
            images: ["Lilo"],
            name: "Lilo",
            author: "John Doe",
            price: 1.78,
            rating: 3,
            isFavorite: true
        ),
        ProfileNFT(
            id: "2",
            images: ["Pixi"],
            name: "Spring",
            author: "Jane Smith",
            price: 2.45,
            rating: 5,
            isFavorite: false
        ),
        ProfileNFT(
            id: "3",
            images: ["April"],
            name: "April",
            author: "John Doe",
            price: 0.99,
            rating: 4,
            isFavorite: true
        ),
        ProfileNFT(
            id: "4",
            images: ["April"],
            name: "April",
            author: "John Doe",
            price: 0.99,
            rating: 4,
            isFavorite: true
        ),
        ProfileNFT(
            id: "5",
            images: ["April"],
            name: "April",
            author: "John Doe",
            price: 0.99,
            rating: 4,
            isFavorite: true
        ),
        ProfileNFT(
            id: "6",
            images: ["April"],
            name: "April",
            author: "John Doe",
            price: 0.99,
            rating: 4,
            isFavorite: true
        )
    ]
}
