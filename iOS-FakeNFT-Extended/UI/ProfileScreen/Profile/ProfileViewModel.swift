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
final class ProfileViewModel: ObservableObject {
    
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
}
