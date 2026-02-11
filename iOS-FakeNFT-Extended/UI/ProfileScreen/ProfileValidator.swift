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
            return .invalid("Имя не может быть пустым")
        }
        
        guard trimmed.count >= 2 else {
            return .invalid("Имя должно содержать минимум 2 символа")
        }
        
        guard trimmed.count <= 30 else {
            return .invalid("Имя не должно превышать 30 символов")
        }
        
        return .valid
    }
    
    // MARK: - Description Validation
    
    static func validateDescription(_ description: String) -> ValidationResult {
        let trimmed = description.trimmingCharacters(in: .whitespaces)
        
        guard !trimmed.isEmpty else {
            return .invalid("Описание не может быть пустым")
        }
        
        guard trimmed.count <= 300 else {
            return .invalid("Описание не может быть длиннее 300 символов")
        }
        
        return .valid
    }
    
    // MARK: - Website URL Validation
    
    static func validateWebsite(_ website: String) -> ValidationResult {
        let trimmed = website.trimmingCharacters(in: .whitespaces)
        
        guard !trimmed.isEmpty else {
            return .valid
        }
        
        let urlPattern = #"^([a-zA-Z0-9]([a-zA-Z0-9\-]{0,61}[a-zA-Z0-9])?\.)+[a-zA-Z]{2,}$"#
        let urlPredicate = NSPredicate(format: "SELF MATCHES %@", urlPattern)
        
        guard urlPredicate.evaluate(with: trimmed) else {
            return .invalid("Неверный формат сайта. Пример: example.com")
        }
        
        return .valid
    }
    
    // MARK: - Avatar URL Validation
    
    static func validateAvatarURL(_ avatar: String) -> ValidationResult {
        let trimmed = avatar.trimmingCharacters(in: .whitespaces)
        
        guard !trimmed.isEmpty else {
            return .valid
        }
        
        guard let url = URL(string: trimmed) else {
            return .invalid("Неверный формат URL")
        }
        
        guard url.scheme == "http" || url.scheme == "https" else {
            return .invalid("URL должен начинаться с http:// или https://")
        }
        
        var validExtensions = ["jpg", "png", "jpeg", "webp"]
        let pathExtension = url.pathExtension.lowercased()
        
        if !pathExtension.isEmpty && !validExtensions.contains(pathExtension) {
            return .invalid("Поддерживаемые форматы: JPG, PNG, JPEG, WEBP")
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
