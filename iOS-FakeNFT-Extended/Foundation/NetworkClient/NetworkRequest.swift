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
    /// Один ключ — одно значение (для простых форм). Используется каталогом (лайки, корзина).
    var formBody: [String: String]? { get }
    /// Пары ключ–значение (один ключ может повторяться). Приоритет над formBody.
    var formBodyPairs: [(String, String)]? { get }
    /// Кастомные заголовки (эпик Корзина).
    var headers: [String: String]? { get }
    /// Сырое тело запроса (эпик Корзина).
    var bodyData: Data? { get }
}

// default values
extension NetworkRequest {
    var httpMethod: HttpMethod { .get }
    var dto: Encodable? { nil }
    var formBody: [String: String]? { nil }
    var formBodyPairs: [(String, String)]? { nil }
    var headers: [String: String]? { nil }
    var bodyData: Data? { nil }
}
