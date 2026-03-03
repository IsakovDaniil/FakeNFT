//
//  PaymentResult.swift
//  iOS-FakeNFT-Extended
//
//  Created by Sultan Akhmetbek on 12.02.2026.
//

struct PaymentResult: Decodable {
    let success: Bool
    let orderId: String
    let id: String
}
