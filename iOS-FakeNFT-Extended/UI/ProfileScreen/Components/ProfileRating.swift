//
//  ProfileRating.swift
//  iOS-FakeNFT-Extended
//
//  Created by Даниил on 17.02.2026.
//

import SwiftUI

struct ProfileRating: View {
    // MARK: - Properties
    
    let rating: String
    
    private let maxRating = 5
    
    private var ratingValue: Int {
        Int(rating) ?? 0
    }
    
    // MARK: - Body
    
    var body: some View {
        HStack(spacing: 2) {
            ForEach(1...maxRating, id: \.self) { star in
                Image(.stars)
                    .foregroundStyle(star <= ratingValue ? .appYellow : .appLightGray)
            }
        }
    }
}

// MARK: - Preview

#Preview {
    VStack(spacing: 10) {
        ProfileRating(rating: "1")
        ProfileRating(rating: "2")
        ProfileRating(rating: "3")
        ProfileRating(rating: "4")
        ProfileRating(rating: "5")
    }
}
