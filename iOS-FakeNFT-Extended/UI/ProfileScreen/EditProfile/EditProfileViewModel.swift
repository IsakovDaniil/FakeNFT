//
//  EditProfileViewModel.swift
//  iOS-FakeNFT-Extended
//
//  Created by Даниил on 10.02.2026.
//

import SwiftUI
import Observation

final class EditProfileViewModel{
    
    // MARK: - State
    
    enum ViewState {
        case idle
        case loading
        case saving
        case saved
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
    
    // MARK: - Alert States
    
    var showActionSheet = false
    var showURLAlert = false
    var showExitAlert = false
    var showErrorAlert = false
    var errorMessage: String?
    
    var urlInput = ""
    var hasUnsavedURLChanges = false
    
    // MARK: - Computer Properties
    
    var hasChanges: Bool {
        name != originalName ||
        description != originalDescription ||
        website != originalWebsite ||
        avatarURL != originalAvatarURL
    }
    
    var isLoading: Bool {
        state == .loading || state == .saving
    }
    
    var canSave: Bool {
        hasChanges && !name.trimmingCharacters(in: .whitespaces).isEmpty
    }
    
    
    // MARK: - Methods
    
    func loadProfile(from profile: UserProfile) {
        name = profile.name
        description = profile.description
        website = profile.website
        avatarURL = profile.avatar
        
        originalName = profile.name
        originalDescription = profile.description
        originalWebsite = profile.website
        originalAvatarURL = profile.avatar
    }
    
    func saveProfile() {
        guard canSave else { return }
        
        // TODO: Здесь будет сетевой запрос
        print("Saving profile:")
        print("Name: \(name)")
        print("Description: \(description)")
        print("Website: \(website)")
        print("Avatar: \(avatarURL)")
        
        originalName = name
        originalDescription = description
        originalWebsite = website
        originalAvatarURL = avatarURL
    }
}

