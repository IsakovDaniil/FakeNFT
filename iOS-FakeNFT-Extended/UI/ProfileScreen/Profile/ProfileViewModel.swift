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
    
    // MARK: - State
    
    enum ViewState {
        case idle, loading
        case loaded(UserProfile)
        case error(String)
    }
    
    var state: ViewState = .idle
    
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
    
    var errorMessage: String? {
        if case .error(let message) = state { return message }
        return nil
    }
    
    // MARK: - Methods
    
    func loadProfile() async {
        state = .loading
        // TODO
    }
    
    func retry() async {
        await loadProfile()
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
    
    // MARK: - Private Methods
    
    private func fetchProfile() async throws -> UserProfile {
        // MOCK DATA
        UserProfile(
            name: "Joaquin Phoenix",
            avatar: "https://example.com/avatar.jpg",
            description: "Дизайнер из Казани, люблю цифровое искусство и бейглы.",
            website: "JoaquinPhoenix.com",
            myNfts: Array(repeating: "nft-id", count: 112),
            favoriteNfts: Array(repeating: "fav-id", count: 11),
            id: "user-1"
        )
    }
}
