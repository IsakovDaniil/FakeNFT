//
//  EditProfileButton.swift
//  iOS-FakeNFT-Extended
//
//  Created by Даниил on 07.02.2026.
//

import SwiftUI

struct EditProfileButton: View {
    let name: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(name)
                .font(Font.bold17)
                .foregroundStyle(.appWhite)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 19)
        }
        .background(.appBlack)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        
    }
}

#Preview {
    EditProfileButton(name: "Сохранить") {
        print("ButtonTapped")
    }
}
