//
//  ProfileGetNFTReuqst.swift
//  iOS-FakeNFT-Extended
//
//  Created by Даниил on 19.02.2026.
//

import Foundation

struct ProfileGetNFTRequest: NetworkRequest {
    let nftID: String
    
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/nft/\(nftID)")
    }
    
    var httpMethod: HttpMethod {
        .get
    }
}
