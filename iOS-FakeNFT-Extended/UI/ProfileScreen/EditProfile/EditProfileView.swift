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
    
    // MARK: - Alert States
    
    @State private var showActionSheet = false
    @State private var showURLAlert = false
    @State private var showExitAlert = false
    @State private var urlInput = ""
    @State private var hasUnsavedURLChanges = false
    
    // MARK: - Original Values
    
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
        .confirmationDialog("Фото профиля", isPresented: $showActionSheet, titleVisibility: .visible) {
            Button("Изменить фото") {
                showURLAlert = true
            }
            
            Button("Удалить фото", role: .destructive) {
                print("Удалить фото")
            }
            
            Button("Отмена", role: .cancel) {}
        }
    }
}

// MARK: - Subviews

private extension EditProfileView {
    
    var avatarSection: some View {
        ProfileAvatar(image: Image(.placeholderAvatar), editMode: true) {
            showActionSheet = true
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
