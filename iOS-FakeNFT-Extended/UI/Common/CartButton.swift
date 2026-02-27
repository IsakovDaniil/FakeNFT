//
//  AppButton.swift
//  iOS-FakeNFT-Extended
//
//  Created by Султан Ахметбек on 07.02.2026.
//

import SwiftUI

struct CartButton: View {
    let title: String
    let height: CGFloat?
    let action: () -> Void
    
    init(title: String, height: CGFloat? = 60, action: @escaping () -> Void) {
        self.title = title
        self.height = height
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.bold17)
                .foregroundStyle(.appWhite)
                .frame(maxWidth: .infinity)
                .frame(height: height)
                .background(Color(.appBlack))
                .clipShape(RoundedRectangle(cornerRadius: 16))
        }
    }
}

#Preview {
    CartButton(title: "", height: 60) {
        
    }
}
