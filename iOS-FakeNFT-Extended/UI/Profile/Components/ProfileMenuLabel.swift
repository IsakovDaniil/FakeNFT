//
//  ProfileMenuLabel.swift
//  iOS-FakeNFT-Extended
//
//  Created by Даниил on 07.02.2026.
//

import SwiftUI

struct ProfileMenuLabel: View {
    let title: String
    let count: Int
    
    var body: some View {
        HStack(spacing: 8) {
            Text(title)
                .font(Font.bold17)
                .foregroundStyle(.appBlack)
            
            Text("(\(count))")
                .font(Font.bold17)
                .foregroundStyle(.appBlack)
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.system(size: 14, weight: .bold))
                .foregroundStyle(.appBlack)
            
        }
        .frame(height: 54)
    }
}

#Preview {
    ProfileMenuLabel(title: "Мои NFT", count: 112)
    
    ProfileMenuLabel(title: "Мои NFT", count: 112)
}
