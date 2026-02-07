//
//  EditProfileView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Даниил on 07.02.2026.
//

import SwiftUI

struct EditProfileView: View {
    var body: some View {
        VStack(spacing: 20) {
            ProfileAvatar(image: Image(.placeholderAvatar), editMode: true)
            
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
            
            Spacer()
            
            EditProfileButton(name: "Сохранить") {
                print("tap")
            }
        }
        .padding()
    }
}

#Preview {
    EditProfileView()
}
