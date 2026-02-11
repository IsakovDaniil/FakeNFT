//
//  CollectionsRequest.swift
//  iOS-FakeNFT-Extended
//
//  Created by Владимир Брюковкин on 10.02.2026.
//

import Foundation

struct CollectionsRequest: NetworkRequest {
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/collections")
    }
}
