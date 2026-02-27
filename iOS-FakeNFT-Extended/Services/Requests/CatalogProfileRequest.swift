//
//  CatalogProfileRequest.swift
//  iOS-FakeNFT-Extended
//
//  Created by Владимир Брюковкин on 16.02.2026.
//

import Foundation

struct CatalogProfileRequest: NetworkRequest {
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/profile/1")
    }
}

// MARK: - PUT profile (update likes). По уроку: Content-Type application/x-www-form-urlencoded, в body — только обновляемые поля.

struct CatalogProfileUpdateRequest: NetworkRequest {
    private let likes: [String]

    init(likes: [String]) {
        self.likes = likes
    }

    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/profile/1")
    }

    var httpMethod: HttpMethod { .put }

    /// Формат как в Postman: несколько полей с ключом "likes" — likes=id1&likes=id2. При пустом массиве — передаем "null" (очистка избранного).
    var formBodyPairs: [(String, String)]? {
        likes.isEmpty ? [("likes", "null")] : likes.map { ("likes", $0) }
    }
}
