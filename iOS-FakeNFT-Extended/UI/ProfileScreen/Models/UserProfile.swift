//
//  Profile.swift
//  iOS-FakeNFT-Extended
//
//  Created by Даниил on 08.02.2026.
//

import Foundation

struct UserProfile: Codable {
    let name: String
    let avatar: String
    let description: String
    let website: String
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
        case name, avatar, description, website, id
        case myNfts = "nfts"
        case favoriteNfts = "likes"
    }
}

extension UserProfile {
    func with(favoriteNfts: [String]) -> UserProfile {
        UserProfile(
            name: name,
            avatar: avatar,
            description: description,
            website: website,
            myNfts: myNfts,
            favoriteNfts: favoriteNfts,
            id: id
        )
    }
}
