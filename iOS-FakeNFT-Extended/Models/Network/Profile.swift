//
//  Profile.swift
//  iOS-FakeNFT-Extended
//
//  Created by Владимир Брюковкин on 16.02.2026.
//

import Foundation

struct Profile: Decodable, Sendable {
    let id: String
    let likes: [String]
}
