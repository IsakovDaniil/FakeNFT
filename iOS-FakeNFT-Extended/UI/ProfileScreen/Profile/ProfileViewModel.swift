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
    
    private let profileService: ProfileServiceProtocol
    
    // MARK: - State
    
    enum ViewState {
        case idle, loading
        case loaded(UserProfile)
        case error(Error)
    }
    
    var state: ViewState = .idle
    
    // MARK: - Alert State
    
    var showErrorAlert = false
    var errorMessage: String?
    
    // MARK: - Navigation State
    
    var showEditProfile = false
    var showWebView = false
    var showMyNFT = false
    var showFavoriteNFT = false
    
    // MARK: - Computed Properties
    
    var profile: UserProfile? {
        if case .loaded(let profile) = state {
            return profile
        }
        return nil
    }
    
    var isLoading: Bool {
        if case .loading = state { return true }
        return false
    }
    
    // MARK: - Init
    
    init(profileService: ProfileServiceProtocol) {
        self.profileService = profileService
    }
    
    // MARK: - Methods
    
    func loadProfile() async {
        state = .loading
        
        do {
            let profile = try await profileService.loadProfile(forceRefresh: false)
            state = .loaded(profile)
        } catch {
            handleError(error)
        }
    }
    
    func retry() async {
        await loadProfile()
    }
    
    func refreshProfile() async {
        print("🔄 Refreshing profile from server...")
        do {
            let profile = try await profileService.loadProfile(forceRefresh: true)
            state = .loaded(profile)
            print("✅ Profile refreshed and UI updated")
        } catch {
            print("⚠️ Silent refresh failed: \(error)")
        }
    }
    
    // MARK: - Navigation Actions
    
    func openEditProfile() {
        showEditProfile = true
    }
    
    func openWebsite() {
        guard profile?.website != nil else { return }
        
        showWebView = true
    }
    
    func openMyNFT() {
        showMyNFT = true
    }
    
    func openFavoriteNFT() {
        showFavoriteNFT = true
    }
    
    func createEditViewModel() -> EditProfileViewModel? {
        EditProfileViewModel(profileService: profileService)
    }
    
    // MARK: - Private Methods
    
    private func handleError(_ error: Error) {
        state = .error(error)
        
        if let networkError = error as? NetworkClientError {
            switch networkError {
            case .httpStatusCode(let code):
                errorMessage = "Ошибка сервера: \(code)"
            case .urlSessionError:
                errorMessage = "Ошибка подключения"
            case .parsingError:
                errorMessage = "Ошибка обработки данных"
            case .incorrectRequest(let message):
                errorMessage = "Некорректрый запрос: \(message)"
            case .urlRequestError:
                errorMessage = "Ошибка сети"
            }
        } else {
            errorMessage = "Не удалось загрузить профиль"
        }
        
        showErrorAlert = true
    }
}
