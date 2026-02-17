//
//  ProfileNFT.swift
//  iOS-FakeNFT-Extended
//
//  Created by Даниил on 17.02.2026.
//

import Foundation

struct ProfileNFT: Identifiable {
    let id = UUID()
    let image: String
    let name: String
    let author: String
    let price: String
    let rating: String
    let isLiked: Bool
}
