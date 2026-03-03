//
//  CurrencyListRequest.swift
//  iOS-FakeNFT-Extended
//
//  Created by Sultan Akhmetbek on 12.02.2026.
//

import Foundation

struct CurrencyListRequest: NetworkRequest {
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/currencies")
    }
    
    var httpMethod: HttpMethod { .get }
}
