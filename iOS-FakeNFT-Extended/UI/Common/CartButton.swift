//
//  AppButton.swift
//  iOS-FakeNFT-Extended
//
//  Created by Султан Ахметбек on 07.02.2026.
//

import SwiftUI

struct CartButton: View {
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.bold17)
                .foregroundStyle(.appWhite)
                .frame(maxWidth: .infinity)
                .frame(height: 44)
                .background(Color(.appBlack))
                .clipShape(RoundedRectangle(cornerRadius: 16))
        }
    }
}

#Preview {
    CartButton(title: "") {
        
    }
}
