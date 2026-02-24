//
//  EditProfileViewModel.swift
//  iOS-FakeNFT-Extended
//
//  Created by Даниил on 10.02.2026.
//

import SwiftUI
import Observation

@Observable
@MainActor
final class EditProfileViewModel {

    // MARK: - Dependencies

    private let profileService: ProfileServiceProtocol
    private var originalProfile: UserProfile?

    // MARK: - State

    enum ViewState {
        case idle, loading, saving, saved, error(Error)
    }

    var state: ViewState = .idle

    // MARK: - Profile Fields

    var name: String = ""
    var description: String = ""
    var website: String = ""
    var avatarURL: String = ""

    // MARK: - Original Values

    private var originalName: String = ""
    private var originalDescription: String = ""
    private var originalWebsite: String = ""
    private var originalAvatarURL: String = ""

    // MARK: - Validation States

    var nameError: String?
    var descriptionError: String?
    var websiteError: String?
    var avatarURLError: String?

    // MARK: - Alert States

    var showActionSheet = false
    var showURLAlert = false
    var showExitAlert = false
    var showErrorAlert = false
    var errorMessage: String?
    var urlInput = ""
    var hasUnsavedURLChanges = false

    // MARK: - Callbacks

    var onProfileSaved: (() -> Void)?

    // MARK: - Computed Properties

    var hasChanges: Bool {
        name != originalName ||
        description != originalDescription ||
        website != originalWebsite ||
        avatarURL != originalAvatarURL
    }

    var isSaving: Bool {
        if case .saving = state { return true }
        return false
    }

    var canSave: Bool {
        guard hasChanges else { return false }
        return ProfileValidator.validateAllFields(
            name: name,
            description: description,
            website: website,
            avatarURL: avatarURL
        ).isValid
    }

    // MARK: - Init

    init(profileService: ProfileServiceProtocol) {
        self.profileService = profileService
    }

    // MARK: - Methods

    func loadProfile(from profile: UserProfile) {
        originalProfile = profile
        name = profile.name
        description = profile.description
        website = profile.website
        avatarURL = profile.avatar
        originalName = profile.name
        originalDescription = profile.description
        originalWebsite = profile.website
        originalAvatarURL = profile.avatar
    }

    func saveProfile() async {
        clearErrors()

        let validationResult = ProfileValidator.validateAllFields(
            name: name,
            description: description,
            website: website,
            avatarURL: avatarURL
        )

        guard validationResult.isValid else {
            errorMessage = validationResult.errorMessage
            showErrorAlert = true
            return
        }

        guard let originalProfile else {
            errorMessage = ProfileConstants.EditProfile.profileNotFoundError
            showErrorAlert = true
            return
        }

        state = .saving

        do {
            let updatedProfile = UserProfile(
                name: name,
                avatar: avatarURL,
                description: description,
                website: website,
                myNfts: originalProfile.myNfts,
                favoriteNfts: originalProfile.favoriteNfts,
                id: originalProfile.id
            )

            let savedProfile = try await profileService.updateProfile(updatedProfile)

            originalName = savedProfile.name
            originalDescription = savedProfile.description
            originalWebsite = savedProfile.website
            originalAvatarURL = savedProfile.avatar

            state = .saved
            onProfileSaved?()

        } catch {
            handleError(error)
        }
    }

    // MARK: - Validation

    func validateName() {
        nameError = ProfileValidator.validateName(name).errorMessage
    }

    func validateDescription() {
        descriptionError = ProfileValidator.validateDescription(description).errorMessage
    }

    func validateWebsite() {
        websiteError = ProfileValidator.validateWebsite(website).errorMessage
    }

    func validateAvatarURL() {
        avatarURLError = ProfileValidator.validateAvatarURL(avatarURL).errorMessage
    }

    // MARK: - Avatar Actions

    func openAvatarActionSheet() {
        showActionSheet = true
    }

    func changeAvatar() {
        showURLAlert = true
    }

    func deleteAvatar() {
        avatarURL = ""
        avatarURLError = nil
    }

    func saveAvatarURL() {
        let trimmed = urlInput.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else { return }

        let result = ProfileValidator.validateAvatarURL(trimmed)

        if result.isValid {
            avatarURL = trimmed
            urlInput = ""
            hasUnsavedURLChanges = false
            avatarURLError = nil
        } else {
            errorMessage = result.errorMessage
            showErrorAlert = true
        }
    }

    func cancelURLInput() {
        if hasUnsavedURLChanges {
            showURLAlert = false
            showExitAlert = true
        } else {
            urlInput = ""
        }
    }

    // MARK: - Private

    private func clearErrors() {
        nameError = nil
        descriptionError = nil
        websiteError = nil
        avatarURLError = nil
    }

    private func handleError(_ error: Error) {
        state = .error(error)

        if let networkError = error as? NetworkClientError {
            switch networkError {
            case .httpStatusCode(let code):
                errorMessage = ProfileConstants.ErrorMessages.serverErrorPrefix + "\(code)"
            case .urlSessionError:
                errorMessage = ProfileConstants.ErrorMessages.connectionError
            case .parsingError:
                errorMessage = ProfileConstants.ErrorMessages.parsingError
            case .incorrectRequest(let message):
                errorMessage = ProfileConstants.ErrorMessages.invalidRequestPrefix + message
            case .urlRequestError:
                errorMessage = ProfileConstants.ErrorMessages.networkError
            }
        } else {
            errorMessage = ProfileConstants.EditProfile.defaultErrorMessage
        }

        showErrorAlert = true
    }
}
