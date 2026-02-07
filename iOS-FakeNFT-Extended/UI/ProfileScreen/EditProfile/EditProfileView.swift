//
//  EditProfileView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Даниил on 07.02.2026.
//

import SwiftUI

struct EditProfileView: View {
    
    // MARK: - Properties
    
    @State private var name: String = "Joaquin Phoenix"
    @State private var description: String = "Дизайнер из Казани, люблю цифровое искусство и бейглы. В моей коллекции уже 100+ NFT, и еще больше — на моём сайте. Открыт к коллаборациям."
    @State private var website: String = "Joaquin Phoenix.com"
    
    // MARK: - Body
    
    var body: some View {
        VStack(spacing: 20) {
            avatarSection
            
            fieldsSection
            
            Spacer()
            
            buttonSection
        }
        .padding()
    }
}

// MARK: - Subviews

private extension EditProfileView {
    
    var avatarSection: some View {
        ProfileAvatar(image: Image(.placeholderAvatar), editMode: true) {
            print("tap")
        }
    }
    
    var fieldsSection: some View {
        VStack(spacing: 20) {
            EditProfileField(title: "Имя", text: $name, isMultiline: false)
            EditProfileField(title: "Описание", text: $description, isMultiline: true)
            EditProfileField(title: "Сайт", text: $website, isMultiline: false)
        }
    }
    
    var buttonSection: some View {
        EditProfileButton(name: "Сохранить") {
            print("tap button")
        }
    }
}

#Preview {
    EditProfileView()
}
