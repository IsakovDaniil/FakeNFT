//
//  ProfileViewModel.swift
//  iOS-FakeNFT-Extended
//
//  Created by Даниил on 09.02.2026.
//
import Foundation
import Observation

@Observable
@MainActor
final class ProfileViewModel {

    // MARK: - Dependencies

    private let store: ProfileStateStore

    // MARK: - Alert State

    var showErrorAlert = false
    var errorMessage: String?

    // MARK: - Navigation State

    var showEditProfile = false
    var showWebView = false
    var showMyNFT = false
    var showFavoriteNFT = false

    // MARK: - Computed Properties

    var profile: UserProfile? { store.profile }

    var isLoading: Bool {
        if case .loading = store.loadingState { return true }
        return false
    }

    // MARK: - Init

    init(store: ProfileStateStore) {
        self.store = store
    }

    // MARK: - Methods

    func loadProfile() async {
        await store.loadAll()
        handleStoreError()
    }

    func retry() async {
        await store.loadAll(forceRefresh: true)
        handleStoreError()
    }

    func refreshProfile() async {
        await store.loadAll(forceRefresh: true)
    }

    // MARK: - Navigation Actions

    func openEditProfile() { showEditProfile = true }
    func openWebsite()     { guard profile?.website != nil else { return }; showWebView = true }
    func openMyNFT()       { showMyNFT = true }
    func openFavoriteNFT() { showFavoriteNFT = true }

    // MARK: - Factory Methods

    func createEditViewModel(profileService: ProfileServiceProtocol) -> EditProfileViewModel {
        EditProfileViewModel(profileService: profileService)
    }

    func createMyNFTViewModel() -> MyNFTViewModel {
        MyNFTViewModel(store: store)
    }

    func createFavoriteNFTViewModel() -> FavoriteNFTViewModel {
        FavoriteNFTViewModel(store: store)
    }

    // MARK: - Private

    private func handleStoreError() {
        if case .error(let message) = store.loadingState {
            errorMessage = message
            showErrorAlert = true
        }
    }
}
