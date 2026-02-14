//
//  EditProfileView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Даниил on 07.02.2026.
//

import SwiftUI
import ProgressHUD

struct EditProfileView: View {
    
    // MARK: - Properties
    
    @Environment(\.dismiss) private var dismiss
    @State private var viewModel: EditProfileViewModel
    
    let profile: UserProfile
    let onProfileUpdated: (() -> Void)?
    
    // MARK: - Init
    
    init(
        profile: UserProfile,
        viewModel: EditProfileViewModel,
        onProfileUpdated: (() -> Void)? = nil
    ) {
        self.profile = profile
        self._viewModel = State(initialValue: viewModel)
        self.onProfileUpdated = onProfileUpdated
    }
    
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
            setupCallbacks()
        }
        .onChange(of: viewModel.isSaving) { _, isSaving in
            if isSaving {
                ProgressHUD.animate()
            } else {
                ProgressHUD.dismiss()
            }
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
    
    // MARK: - Private Methods
    
    private func setupCallbacks() {
        viewModel.onProfileSaved = { [onProfileUpdated, dismiss] in
            Task { @MainActor in
                ProgressHUD.succeed("Сохранено")
                try? await Task.sleep(nanoseconds: 500_000_000) // 0.5 sec
                dismiss()
                onProfileUpdated?()
            }
        }
    }
}

// MARK: - Subviews

private extension EditProfileView {
    
    var avatarSection: some View {
        ProfileAvatar(
            urlString: viewModel.avatarURL.isEmpty ? nil : viewModel.avatarURL,
            editMode: true,
            onTap: {
                viewModel.openAvatarActionSheet()
            }
        )
    }
    
    var fieldsSection: some View {
        VStack(spacing: 20) {
            VStack(alignment: .leading, spacing: 4) {
                EditProfileField(title: "Имя", text: $viewModel.name, isMultiline: false)
                    .onChange(of: viewModel.name) { _, _ in
                        viewModel.validateName()
                    }
                
                if let error = viewModel.nameError {
                    Text(error)
                        .font(.caption)
                        .foregroundColor(.red)
                }
            }
            
            VStack(alignment: .leading, spacing: 4) {
                EditProfileField(title: "Описание", text: $viewModel.description, isMultiline: true)
                    .onChange(of: viewModel.description) { _, _ in
                        viewModel.validateDescription()
                    }
                
                if let error = viewModel.descriptionError {
                    Text(error)
                        .font(.caption)
                        .foregroundColor(.red)
                }
            }
            
            VStack(alignment: .leading, spacing: 4) {
                EditProfileField(title: "Сайт", text: $viewModel.website, isMultiline: false)
                    .onChange(of: viewModel.website) { _, _ in
                        viewModel.validateWebsite()
                    }
                
                if let error = viewModel.websiteError {
                    Text(error)
                        .font(.caption)
                        .foregroundColor(.red)
                }
            }
        }
    }
    
    var buttonSection: some View {
        EditProfileButton(name: "Сохранить") {
            Task {
                await viewModel.saveProfile()
            }
        }
        .disabled(!viewModel.canSave || viewModel.isSaving)
        .opacity(viewModel.hasChanges && !viewModel.isSaving ? 1.0 : 0)
    }
}
