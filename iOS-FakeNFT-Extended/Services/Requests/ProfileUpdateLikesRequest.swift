//
//  ProfileGetNFTReuqst.swift
//  iOS-FakeNFT-Extended
//
//  Created by Даниил on 19.02.2026.
//

import Foundation

struct ProfileUpdateLikesRequest: NetworkRequest {
    let likes: [String]
    
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/profile/1")
    }
    
    var httpMethod: HttpMethod {
        .put
    }
    
    func createFormBody() -> Data? {
        let likesString = likes.joined(separator: ",")
        return "likes=\(likesString)".data(using: .utf8)
    }
}
































































































































