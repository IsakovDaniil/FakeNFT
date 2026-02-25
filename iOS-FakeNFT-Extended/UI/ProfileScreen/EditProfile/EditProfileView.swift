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
        VStack(spacing: 0) {
            ScrollView {
                VStack(spacing: 20) {
                    avatarSection
                    fieldsSection
                }
                .padding()
            }
            .background(Color.appWhite)
            .simultaneousGesture(
                TapGesture()
                    .onEnded { _ in hideKeyboard() }
            )
            
            if viewModel.hasChanges && !viewModel.isSaving {
                buttonSection
                    .padding()
                    .background(Color.appWhite)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
        .background(Color.appWhite.ignoresSafeArea())
        .onAppear {
            viewModel.loadProfile(from: profile)
            setupCallbacks()
        }
        .animation(.easeInOut(duration: 0.3), value: viewModel.hasChanges)
        .onChange(of: viewModel.isSaving) { _, isSaving in
            isSaving ? ProgressHUD.animate() : ProgressHUD.dismiss()
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
        .confirmationDialog(
            ProfileConstants.EditProfile.avatarActionSheetTitle,
            isPresented: $viewModel.showActionSheet,
            titleVisibility: .visible
        ) {
            Button(ProfileConstants.EditProfile.changePhoto) {
                viewModel.changeAvatar()
            }
            Button(ProfileConstants.EditProfile.deletePhoto, role: .destructive) {
                viewModel.deleteAvatar()
            }
            Button(ProfileConstants.EditProfile.cancel, role: .cancel) {}
        }
        .alert(ProfileConstants.EditProfile.urlAlertTitle, isPresented: $viewModel.showURLAlert) {
            TextField(ProfileConstants.EditProfile.urlPlaceholder, text: $viewModel.urlInput)
                .textInputAutocapitalization(.never)
                .keyboardType(.URL)
                .onChange(of: viewModel.urlInput) { _, _ in
                    viewModel.hasUnsavedURLChanges = true
                }
            Button(ProfileConstants.EditProfile.cancel, role: .cancel) {
                viewModel.cancelURLInput()
            }
            Button(ProfileConstants.EditProfile.save) {
                viewModel.saveAvatarURL()
            }
            .disabled(viewModel.urlInput.isEmpty)
        }
        .alert(ProfileConstants.EditProfile.exitConfirmationTitle, isPresented: $viewModel.showExitAlert) {
            Button(ProfileConstants.EditProfile.stay, role: .cancel) {}
            Button(ProfileConstants.EditProfile.exit, role: .destructive) {
                dismiss()
            }
        }
        .alert(ProfileConstants.errorAlertTitle, isPresented: $viewModel.showErrorAlert) {
            Button(ProfileConstants.EditProfile.okay, role: .cancel) {}
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
                ProgressHUD.succeed(ProfileConstants.EditProfile.savedMessage)
                try? await Task.sleep(for: .seconds(0.5))
                dismiss()
                onProfileUpdated?()
            }
        }
    }
    
    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

// MARK: - Subviews

private extension EditProfileView {
    
    var avatarSection: some View {
        ProfileAvatar(
            urlString: viewModel.avatarURL.isEmpty ? nil : viewModel.avatarURL,
            editMode: true,
            onTap: { viewModel.openAvatarActionSheet() }
        )
    }
    
    var fieldsSection: some View {
        VStack(spacing: 20) {
            VStack(alignment: .leading, spacing: 4) {
                EditProfileField(
                    title: ProfileConstants.EditProfile.fieldName,
                    text: $viewModel.name,
                    isMultiline: false
                )
                .onChange(of: viewModel.name) { _, _ in viewModel.validateName() }
                
                if let error = viewModel.nameError {
                    Text(error)
                        .font(.caption)
                        .foregroundColor(.red)
                }
            }
            
            VStack(alignment: .leading, spacing: 4) {
                EditProfileField(
                    title: ProfileConstants.EditProfile.fieldDescription,
                    text: $viewModel.description,
                    isMultiline: true
                )
                .onChange(of: viewModel.description) { _, _ in viewModel.validateDescription() }
                
                if let error = viewModel.descriptionError {
                    Text(error)
                        .font(.caption)
                        .foregroundColor(.red)
                }
            }
            
            VStack(alignment: .leading, spacing: 4) {
                EditProfileField(
                    title: ProfileConstants.EditProfile.fieldWebsite,
                    text: $viewModel.website,
                    isMultiline: false
                )
                .onChange(of: viewModel.website) { _, _ in viewModel.validateWebsite() }
                
                if let error = viewModel.websiteError {
                    Text(error)
                        .font(.caption)
                        .foregroundColor(.red)
                }
            }
        }
    }
    
    var buttonSection: some View {
        EditProfileButton(name: ProfileConstants.EditProfile.save) {
            hideKeyboard()
            Task { await viewModel.saveProfile() }
        }
        .disabled(!viewModel.canSave || viewModel.isSaving)
    }
}
