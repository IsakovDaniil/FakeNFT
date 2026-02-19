//
//  PaymentRequest.swift
//  iOS-FakeNFT-Extended
//
//  Created by Sultan Akhmetbek on 12.02.2026.
//

import Foundation

struct PaymentRequest: NetworkRequest {
    let currencyId: String
    
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/orders/1/payment/\(currencyId)")
    }
    
    var httpMethod: HttpMethod { .get }
}
