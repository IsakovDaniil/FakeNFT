import Foundation

enum HttpMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

protocol NetworkRequest {
    var endpoint: URL? { get }
    var httpMethod: HttpMethod { get }
    var dto: Encodable? { get }
    /// Один ключ — одно значение (для простых форм).
    var formBody: [String: String]? { get }
    /// Пары ключ–значение (один ключ может повторяться, например likes=id1&likes=id2). Приоритет над formBody.
    var formBodyPairs: [(String, String)]? { get }
}

// default values
extension NetworkRequest {
    var httpMethod: HttpMethod { .get }
    var dto: Encodable? { nil }
    var formBody: [String: String]? { nil }
    var formBodyPairs: [(String, String)]? { nil }
}
