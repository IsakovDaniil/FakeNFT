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
    @State private var description: String = "bio"
    @State private var website: String = "app.ru"
    
    private let originalName: String = "Joaquin Phoenix"
    private let originalDescription: String = "bio"
    private let originalWebsite: String = "app.ru"
    
    private var hasChanges: Bool {
        name != originalName ||
        description != originalDescription ||
        website != originalWebsite
    }
    
    // MARK: - Body
    
    var body: some View {
        ZStack {
            Color.appWhite
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 20) {
                    avatarSection
                    fieldsSection
                }
                .padding()
            }
            .safeAreaInset(edge: .bottom) {
                buttonSection
                    .padding()
            }
        }
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
        .disabled(!hasChanges)
        .opacity(hasChanges ? 1.0 : 0)
    }
}

#Preview {
    EditProfileView()
}
