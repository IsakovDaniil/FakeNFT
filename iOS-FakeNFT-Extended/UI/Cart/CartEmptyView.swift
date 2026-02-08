//
//  CartEmptyView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Султан Ахметбек on 08.02.2026.
//

import SwiftUI

struct CartEmptyView: View {
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image(systemName: "cart")
                .font(.system(size: 60))
                .foregroundStyle(.secondary)
            
            Text("Корзина пуста")
                .font(.bold17)
            
            Text("Добавьте NFT в корзину")
                .font(.regular15)
                .foregroundStyle(.secondary)
            
            Spacer()
        }
    }
}

#Preview {
    CartEmptyView()
}
