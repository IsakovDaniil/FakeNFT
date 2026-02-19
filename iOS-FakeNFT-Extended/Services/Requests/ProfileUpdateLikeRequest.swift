//
//  ProfileGetNFTReuqst.swift
//  iOS-FakeNFT-Extended
//
//  Created by Даниил on 19.02.2026.
//

import Foundation

struct ProfileUpdateLikeRequest: NetworkRequest {
    let profileID: String
    let likes: [String]
    
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/profile/\(profileID)")
    }
    
    var httpMethod: HttpMethod {
        .put
    }
    
    func createFromBody() -> Data? {
        let likesString = likes.joined(separator: ",")
        let fromString = "likes=\(likesString)"
        return fromString.data(using: .utf8)
    }
}
