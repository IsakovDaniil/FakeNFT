import Foundation

struct OrderRequest: NetworkRequest {
    let sort: String?

    var endpoint: URL? {
        var components = URLComponents(string: "\(RequestConstants.baseURL)/api/v1/orders/1")
        if let sort, !sort.isEmpty {
            var queryItems = components?.queryItems ?? []
            queryItems.append(URLQueryItem(name: "sortBy", value: sort))
            components?.queryItems = queryItems
        }
        return components?.url
    }

    var httpMethod: HttpMethod { .get }
}

struct OrderSaveRequest: NetworkRequest {
    let nfts: [String]
    let method: HttpMethod
    
    init(nfts: [String], method: HttpMethod = .put) {
        self.nfts = nfts
        self.method = method
    }

    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/orders/1")
    }

    var httpMethod: HttpMethod { method }

    var headers: [String: String]? {
        ["Content-Type": "application/x-www-form-urlencoded; charset=utf-8"]
    }

    var bodyData: Data? {
        let pairs: [String] = nfts.map { id in
            let key = "nfts"
            let encodedKey = key.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? key
            let encodedValue = id.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? id
            return "\(encodedKey)=\(encodedValue)"
        }
        let formString = pairs.joined(separator: "&")
        return formString.data(using: .utf8)
    }
}
