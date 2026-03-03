//
//  EditProfileField.swift
//  iOS-FakeNFT-Extended
//
//  Created by Даниил on 07.02.2026.
//

import SwiftUI

struct EditProfileField: View {
    
    let title: String
    @Binding var text: String
    let isMultiline: Bool
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(Font.bold22)
                .foregroundStyle(.appBlack)
            
            if isMultiline {
                TextField("", text: $text, axis: .vertical)
                    .font(Font.regular17)
                    .lineLimit(1...10)
                    .padding(11)
                    .background(.appLightGray)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            } else {
                TextField("", text: $text)
                    .font(Font.regular17)
                    .padding()
                    .background(.appLightGray)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        EditProfileField(
            title: "Имя",
            text: .constant("Joaquin Phoenix"),
            isMultiline: false
        )
        
        EditProfileField(
            title: "Описание",
            text: .constant("Дизайнер из Казани, люблю цифровое искусство и бейглы. В моей коллекции уже 100+ NFT, и еще больше — на моём сайте. Открыт к коллаборациям."),
            isMultiline: true
        )
        
        EditProfileField(
            title: "Сайт",
            text: .constant("app.ru"),
            isMultiline: false
        )
    }
}
