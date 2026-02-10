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
    
}

