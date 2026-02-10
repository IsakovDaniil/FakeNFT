import Foundation

struct OrderRequest: NetworkRequest {
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/orders/1")
    }

    var httpMethod: HttpMethod { .get }
}

struct OrderSaveRequest: NetworkRequest {
    let nfts: [String]

    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/orders/1")
    }

    var httpMethod: HttpMethod { .put }

    var headers: [String: String]? {
        ["Content-Type": "application/x-www-form-urlencoded; charset=utf-8"]
    }

    var bodyData: Data? {
        let pairs: [String] = nfts.map { id in
            let key = "nfts" // или "nfts[]", если сервер ждёт массив с квадратными скобками
            let encodedKey = key.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? key
            let encodedValue = id.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? id
            return "\(encodedKey)=\(encodedValue)"
        }
        let formString = pairs.joined(separator: "&")
        return formString.data(using: .utf8)
    }
}
