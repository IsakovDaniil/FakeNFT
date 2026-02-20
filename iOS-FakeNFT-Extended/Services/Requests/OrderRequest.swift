//
//  OrderRequest.swift
//  iOS-FakeNFT-Extended
//
//  Created by Владимир Брюковкин on 16.02.2026.
//

import Foundation

struct OrderRequest: NetworkRequest {
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/orders/1")
    }
}

// MARK: - PUT order (update cart). Form-urlencoded: nfts=id1&nfts=id2. Пустой массив — тело не отправляется.

struct OrderUpdateRequest: NetworkRequest {
    private let nftIds: [String]

    init(nftIds: [String]) {
        self.nftIds = nftIds
    }

    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/orders/1")
    }

    var httpMethod: HttpMethod { .put }

    var formBodyPairs: [(String, String)]? {
        nftIds.isEmpty ? nil : nftIds.map { ("nfts", $0) }
    }
}
