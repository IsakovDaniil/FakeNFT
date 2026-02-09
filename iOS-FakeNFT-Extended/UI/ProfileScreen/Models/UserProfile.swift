//
//  Profile.swift
//  iOS-FakeNFT-Extended
//
//  Created by Даниил on 08.02.2026.
//

import Foundation

struct UserProfile: Decodable {
    let name: String
    let avatar: String
    let description: String
    let myNfts: [String]
    let favoriteNfts: [String]
    let id: String
    
    var myNftCount: Int {
        return myNfts.count
    }
    
    var favoriteNftCount: Int {
        return favoriteNfts.count
    }
    
    enum CodingKeys: String, CodingKey {
        case name, avatar, description, id
        case myNfts = "nfts"
        case favoriteNfts = "likes"
    }
}
