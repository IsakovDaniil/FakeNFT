//
//  Order.swift
//  iOS-FakeNFT-Extended
//
//  Created by Владимир Брюковкин on 16.02.2026.
//

import Foundation

struct Order: Decodable, Sendable {
    let id: String
    let nfts: [String]
}
