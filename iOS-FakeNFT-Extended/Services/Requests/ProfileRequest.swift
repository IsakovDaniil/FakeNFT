//
//  GetProfileRequest.swift
//  iOS-FakeNFT-Extended
//
//  Created by Даниил on 13.02.2026.
//
import Foundation

// MARK: - Get Profile Request

struct GetProfileRequest: NetworkRequest {
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/profile/1")
    }
}

// MARK: - Update Profile Request

struct UpdateProfileRequest: NetworkRequest {
    let profile: UserProfile
    
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/profile/1")
    }
    
    var httpMethod: HttpMethod {
        .put
    }
    
    var dto: Encodable? {
        nil
    }
    
    func createFormBody() -> Data? {
        var components = URLComponents()
        components.queryItems = [
            URLQueryItem(name: "name", value: profile.name),
            URLQueryItem(name: "description", value: profile.description),
            URLQueryItem(name: "website", value: profile.website),
            URLQueryItem(name: "avatar", value: profile.avatar)
        ]
        
        profile.favoriteNfts.forEach { nftId in
            components.queryItems?.append(URLQueryItem(name: "likes", value: nftId))
        }
        
        return components.percentEncodedQuery?.data(using: .utf8)
    }
}
