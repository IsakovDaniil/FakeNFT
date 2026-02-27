//
//  ProfileValidator.swift
//  iOS-FakeNFT-Extended
//
//  Created by Даниил on 10.02.2026.
//

import Foundation

struct ProfileValidator {
    
    // MARK: - Validation Result
    
    enum ValidationResult {
        case valid
        case invalid(String)
        
        var isValid: Bool {
            if case .valid = self { return true }
            return false
        }
        
        var errorMessage: String? {
            if case .invalid(let message) = self { return message }
            return nil
        }
    }
    
    // MARK: - Name Validation
    
    static func validateName(_ name: String) -> ValidationResult {
        let trimmed = name.trimmingCharacters(in: .whitespaces)
        
        guard !trimmed.isEmpty else {
            return .invalid(ProfileConstants.Validation.nameEmpty)
        }
        
        guard trimmed.count >= 2 else {
            return .invalid(ProfileConstants.Validation.nameTooShort)
        }
        
        guard trimmed.count <= 30 else {
            return .invalid(ProfileConstants.Validation.nameTooLong)
        }
        
        return .valid
    }
    
    // MARK: - Description Validation
    
    static func validateDescription(_ description: String) -> ValidationResult {
        let trimmed = description.trimmingCharacters(in: .whitespaces)
        
        guard !trimmed.isEmpty else {
            return .invalid(ProfileConstants.Validation.descriptionEmpty)
        }
        
        guard trimmed.count <= 300 else {
            return .invalid(ProfileConstants.Validation.descriptionTooLong)
        }
        
        return .valid
    }
    
    // MARK: - Website Validation
    
    static func validateWebsite(_ website: String) -> ValidationResult {
        let trimmed = website.trimmingCharacters(in: .whitespaces)
        
        guard !trimmed.isEmpty else { return .valid }
        
        let urlPattern = #"^(https?:\/\/)?([\w\-]+\.)+[\w\-]+(\/[\w\-\.\/\?\=\&]*)?$"#
        let urlPredicate = NSPredicate(format: "SELF MATCHES %@", urlPattern)
        
        guard urlPredicate.evaluate(with: trimmed) else {
            return .invalid(ProfileConstants.Validation.websiteInvalidFormat)
        }
        
        return .valid
    }
    
    // MARK: - Avatar URL Validation
    
    static func validateAvatarURL(_ avatar: String) -> ValidationResult {
        let trimmed = avatar.trimmingCharacters(in: .whitespaces)
        
        guard !trimmed.isEmpty else { return .valid }
        
        guard let url = URL(string: trimmed) else {
            return .invalid(ProfileConstants.Validation.urlInvalidFormat)
        }
        
        guard url.scheme == "http" || url.scheme == "https" else {
            return .invalid(ProfileConstants.Validation.urlInvalidScheme)
        }
        
        let validExtensions = ["jpg", "png", "jpeg", "webp"]
        let pathExtension = url.pathExtension.lowercased()
        
        if !pathExtension.isEmpty && !validExtensions.contains(pathExtension) {
            return .invalid(ProfileConstants.Validation.urlInvalidExtension)
        }
        
        return .valid
    }
    
    // MARK: - All Fields Validation
    
    static func validateAllFields(
        name: String,
        description: String,
        website: String,
        avatarURL: String
    ) -> ValidationResult {
        let nameResult = validateName(name)
        if !nameResult.isValid { return nameResult }
        
        let descriptionResult = validateDescription(description)
        if !descriptionResult.isValid { return descriptionResult }
        
        let websiteResult = validateWebsite(website)
        if !websiteResult.isValid { return websiteResult }
        
        let avatarResult = validateAvatarURL(avatarURL)
        if !avatarResult.isValid { return avatarResult }
        
        return .valid
    }
}
