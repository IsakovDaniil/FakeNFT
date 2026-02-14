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
        .navigationBarBackButtonHidden(true)
        
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    if viewModel.hasChanges {
                        viewModel.showExitAlert = true
                    } else {
                        dismiss()
                    }
                } label: {
                    Image(systemName: "chevron.left")
                        .foregroundStyle(.appBlack)
                }
            }
        }
        .confirmationDialog(EditProfileConstants.avatarActionSheetTitle, isPresented: $viewModel.showActionSheet, titleVisibility: .visible) {
            Button(EditProfileConstants.changePhoto) {
                viewModel.changeAvatar()
            }
            
            Button(EditProfileConstants.deletePhoto, role: .destructive) {
                viewModel.deleteAvatar()
            }
            
            Button(EditProfileConstants.cancel, role: .cancel) {}
        }
        .alert(EditProfileConstants.urlAlertTitle, isPresented: $viewModel.showURLAlert) {
            TextField(EditProfileConstants.urlPlaceholder, text: $viewModel.urlInput)
                .textInputAutocapitalization(.never)
                .keyboardType(.URL)
                .onChange(of: viewModel.urlInput) { _, _ in
                    viewModel.hasUnsavedURLChanges = true
                }
            
            Button(EditProfileConstants.cancel, role: .cancel) {
                viewModel.cancelURLInput()
            }
            
            Button(EditProfileConstants.save) {
                viewModel.saveAvatarURL()
            }
            .disabled(viewModel.urlInput.isEmpty)
        }
        .alert(EditProfileConstants.exitConfirmationTitle, isPresented: $viewModel.showExitAlert) {
            Button(EditProfileConstants.stay, role: .cancel) {}
            Button(EditProfileConstants.exit, role: .destructive) {
                dismiss()
            }
        }
        .alert(EditProfileConstants.errorAlertTitle, isPresented: $viewModel.showErrorAlert) {
            Button(EditProfileConstants.ok, role: .cancel) {}
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
                ProgressHUD.succeed(EditProfileConstants.savedMessage)
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
                EditProfileField(title: EditProfileConstants.FieldTitles.name, text: $viewModel.name, isMultiline: false)
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
                EditProfileField(title: EditProfileConstants.FieldTitles.description, text: $viewModel.description, isMultiline: true)
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
                EditProfileField(title: EditProfileConstants.FieldTitles.website, text: $viewModel.website, isMultiline: false)
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
        EditProfileButton(name: EditProfileConstants.save) {
            Task {
                await viewModel.saveProfile()
            }
        }
        .disabled(!viewModel.canSave || viewModel.isSaving)
        .opacity(viewModel.hasChanges && !viewModel.isSaving ? 1.0 : 0)
    }
}
