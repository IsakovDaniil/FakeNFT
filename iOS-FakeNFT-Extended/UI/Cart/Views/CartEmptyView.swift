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
            
            Text(CartLn.cartEmpty)
                .font(.bold17)
            
            Text(CartLn.cartAdd)
                .font(.regular15)
                .foregroundStyle(.secondary)
            
            Spacer()
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    CartEmptyView()
}
