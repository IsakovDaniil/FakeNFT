//
//  ProfileGetNFTReuqst.swift
//  iOS-FakeNFT-Extended
//
//  Created by Даниил on 19.02.2026.
//

import Foundation

/// PUT profile/likes: при наличии лайков отправляем likes=id1&likes=id2, а при пустом списке — likes=null для очистки избранного на сервере.
struct ProfileUpdateLikesRequest: NetworkRequest {
    let likes: [String]
    
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/profile/1")
    }
    
    var httpMethod: HttpMethod {
        .put
    }
    
    var formBodyPairs: [(String, String)]? {
        likes.isEmpty ? [("likes", "null")] : likes.map { ("likes", $0) }
    }
}
