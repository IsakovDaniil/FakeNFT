//
//  PaymentRequest.swift
//  iOS-FakeNFT-Extended
//
//  Created by Sultan Akhmetbek on 12.02.2026.
//

import Foundation

struct PaymentRequest: NetworkRequest {
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/orders/1/payment/1")
    }
    
    var httpMethod: HttpMethod { .get }
}
