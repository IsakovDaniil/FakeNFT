//
//  OrderRequest.swift
//  iOS-FakeNFT-Extended
//

import Foundation

struct OrderRequest: NetworkRequest {
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/orders/1")
    }

    var httpMethod: HttpMethod { .get }
}

// MARK: - PUT order (эпик Корзина — bodyData)

struct OrderSaveRequest: NetworkRequest {
    let nfts: [String]

    init(nfts: [String]) {
        self.nfts = nfts
    }

    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/orders/1")
    }

    var httpMethod: HttpMethod { .put }

    var headers: [String: String]? {
        ["Content-Type": "application/x-www-form-urlencoded"]
    }

    var bodyData: Data? {
        if nfts.isEmpty {
            return Data("nfts=null".utf8)
        }
        let pairs: [String] = nfts.map { id in
            let key = "nfts"
            let encodedKey = key.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? key
            let encodedValue = id.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? id
            return "\(encodedKey)=\(encodedValue)"
        }
        let formString = pairs.joined(separator: "&")
        return Data(formString.utf8)
    }
}

// MARK: - PUT order (эпик Каталог — formBodyPairs)

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
        nftIds.isEmpty ? [("nfts", "null")] : nftIds.map { ("nfts", $0) }
    }
}
