import Foundation

struct OrderRequest: NetworkRequest {
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/orders/1")
    }

    var httpMethod: HttpMethod { .get }
}

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
        [
            "Content-Type": "application/x-www-form-urlencoded"
        ]
    }

    var bodyData: Data? {
        guard !nfts.isEmpty else { return nil }

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
