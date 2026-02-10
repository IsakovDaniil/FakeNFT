//
//  EditProfileView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Даниил on 07.02.2026.
//

import SwiftUI

struct EditProfileView: View {
    
    // MARK: - Properties
    
    @Environment(\.dismiss) private var dismiss
    @State private var viewModel = EditProfileViewModel()
    
    let profile: UserProfile
    
    // MARK: - Body
    
    var body: some View {
        ZStack {
            Color.appWhite.ignoresSafeArea()
            
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
        .onAppear {
            viewModel.loadProfile(from: profile)
        }
        .navigationBarBackButtonHidden(viewModel.hasChanges)
        .toolbar {
            if viewModel.hasChanges {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        viewModel.showExitAlert = true
                    } label: {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.appBlack)
                    }
                }
            }
        }
        .confirmationDialog("Фото профиля", isPresented: $viewModel.showActionSheet, titleVisibility: .visible) {
            Button("Изменить фото") {
                viewModel.changeAvatar()
            }
            
            Button("Удалить фото", role: .destructive) {
                viewModel.deleteAvatar()
            }
            
            Button("Отмена", role: .cancel) {}
        }
        .alert("Ссылка на фото", isPresented: $viewModel.showURLAlert) {
            TextField("https://example.com/", text: $viewModel.urlInput)
                .textInputAutocapitalization(.never)
                .keyboardType(.URL)
                .onChange(of: viewModel.urlInput) { _, _ in
                    viewModel.hasUnsavedURLChanges = true
                }
            
            Button("Отмена", role: .cancel) {
                viewModel.cancelURLInput()
            }
            
            Button("Сохранить") {
                viewModel.saveAvatarURL()
            }
            .disabled(viewModel.urlInput.isEmpty)
        }
        .alert("Уверены, что хотите выйти?", isPresented: $viewModel.showExitAlert) {
            Button("Остаться", role: .cancel) {}
            Button("Выйти", role: .destructive) {
                dismiss()
            }
        }
        .alert("Ошибка", isPresented: $viewModel.showErrorAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            if let message = viewModel.errorMessage {
                Text(message)
            }
        }
    }
}

// MARK: - Subviews

private extension EditProfileView {
    
    var avatarSection: some View {
        ProfileAvatar(
            image: Image(.placeholderAvatar),
            editMode: true
        ) {
            viewModel.openAvatarActionSheet()
        }
    }
    
    var fieldsSection: some View {
        VStack(spacing: 20) {
            EditProfileField(title: "Имя", text: $viewModel.name, isMultiline: false)
            EditProfileField(title: "Описание", text: $viewModel.description, isMultiline: true)
            EditProfileField(title: "Сайт", text: $viewModel.website, isMultiline: false)
        }
    }
    
    var buttonSection: some View {
        EditProfileButton(name: "Сохранить") {
            viewModel.saveProfile()
            dismiss()
        }
        .disabled(!viewModel.hasChanges)
        .opacity(viewModel.hasChanges ? 1.0 : 0)
    }
}

#Preview {
    EditProfileView(
        profile: UserProfile(
            name: "Joaquin Phoenix",
            avatar: "https://example.com/avatar.jpg",
            description: "Дизайнер из Казани, люблю цифровое искусство и бейглы.",
            website: "JoaquinPhoenix.com",
            myNfts: [],
            favoriteNfts: [],
            id: "user-1"
        )
    )
}
