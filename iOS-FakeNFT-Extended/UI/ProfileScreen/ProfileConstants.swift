//
//  ProfileConstants.swift
//  iOS-FakeNFT-Extended
//
//  Created by Даниил on 14.02.2026.
//

import Foundation

enum ProfileConstants {
    
    // MARK: - Navigation
    
    static let navigationTitle = NSLocalizedString("Profile.navigationTitle", comment: "")
    
    // MARK: - Alerts
    
    static let errorAlertTitle = NSLocalizedString("Profile.errorAlertTitle", comment: "")
    static let retryButton = NSLocalizedString("Profile.retryButton", comment: "")
    static let cancelButton = NSLocalizedString("Profile.cancelButton", comment: "")
    static let defaultErrorMessage = NSLocalizedString("Profile.defaultErrorMessage", comment: "")
    
    // MARK: - Error Messages
    
    enum ErrorMessages {
        static let serverErrorPrefix = NSLocalizedString("Profile.ErrorMessages.serverErrorPrefix", comment: "")
        static let connectionError = NSLocalizedString("Profile.ErrorMessages.connectionError", comment: "")
        static let parsingError = NSLocalizedString("Profile.ErrorMessages.parsingError", comment: "")
        static let invalidRequestPrefix = NSLocalizedString("Profile.ErrorMessages.invalidRequestPrefix", comment: "")
        static let networkError = NSLocalizedString("Profile.ErrorMessages.networkError", comment: "")
    }
    
    // MARK: - Menu
    
    enum Menu {
        static let myNFTTitle = NSLocalizedString("Profile.Menu.myNFTTitle", comment: "")
        static let favoriteNFTTitle = NSLocalizedString("Profile.Menu.favoriteNFTTitle", comment: "")
    }
    
    // MARK: - Empty State
    
    enum EmptyState {
        static let myNFT = NSLocalizedString("Profile.EmptyState.myNFT", comment: "")
        static let favorite = NSLocalizedString("Profile.EmptyState.favorite", comment: "")
    }
    
    // MARK: - Sort
    
    enum Sort {
        static let byPrice = NSLocalizedString("Profile.Sort.byPrice", comment: "")
        static let byRating = NSLocalizedString("Profile.Sort.byRating", comment: "")
        static let byName = NSLocalizedString("Profile.Sort.byName", comment: "")
    }
    
    // MARK: - My NFT
    
    enum MyNFT {
        static let navigationTitle = NSLocalizedString("Profile.MyNFT.navigationTitle", comment: "")
        static let sortDialogTitle = NSLocalizedString("Profile.MyNFT.sortDialogTitle", comment: "")
        static let closeButtonTitle = NSLocalizedString("Profile.MyNFT.closeButtonTitle", comment: "")
        static let retryButtonTitle = NSLocalizedString("Profile.MyNFT.retryButtonTitle", comment: "")
        static let cancelButtonTitle = NSLocalizedString("Profile.MyNFT.cancelButtonTitle", comment: "")
        static let favoriteUpdateErrorMessage = NSLocalizedString("Profile.MyNFT.favoriteUpdateErrorMessage", comment: "")
    }
    
    // MARK: - Favorite NFT
    
    enum FavoriteNFT {
        static let navigationTitle = NSLocalizedString("Profile.FavoriteNFT.navigationTitle", comment: "")
        static let favoriteUpdateErrorMessage = NSLocalizedString("Profile.FavoriteNFT.favoriteUpdateErrorMessage", comment: "")
    }
    
    // MARK: - Edit Profile
    
    enum EditProfile {
        static let avatarActionSheetTitle = NSLocalizedString("Profile.EditProfile.avatarActionSheetTitle", comment: "")
        static let urlAlertTitle = NSLocalizedString("Profile.EditProfile.urlAlertTitle", comment: "")
        static let exitConfirmationTitle = NSLocalizedString("Profile.EditProfile.exitConfirmationTitle", comment: "")
        static let changePhoto = NSLocalizedString("Profile.EditProfile.changePhoto", comment: "")
        static let deletePhoto = NSLocalizedString("Profile.EditProfile.deletePhoto", comment: "")
        static let cancel = NSLocalizedString("Profile.EditProfile.cancel", comment: "")
        static let save = NSLocalizedString("Profile.EditProfile.save", comment: "")
        static let stay = NSLocalizedString("Profile.EditProfile.stay", comment: "")
        static let exit = NSLocalizedString("Profile.EditProfile.exit", comment: "")
        static let okay = NSLocalizedString("Profile.EditProfile.okay", comment: "")
        static let urlPlaceholder = NSLocalizedString("Profile.EditProfile.urlPlaceholder", comment: "")
        static let savedMessage = NSLocalizedString("Profile.EditProfile.savedMessage", comment: "")
        static let unsavedChangesMessage = NSLocalizedString("Profile.EditProfile.unsavedChangesMessage", comment: "")
        static let defaultErrorMessage = NSLocalizedString("Profile.EditProfile.defaultErrorMessage", comment: "")
        static let profileNotFoundError = NSLocalizedString("Profile.EditProfile.profileNotFoundError", comment: "")
        static let fieldName = NSLocalizedString("Profile.EditProfile.fieldName", comment: "")
        static let fieldDescription = NSLocalizedString("Profile.EditProfile.fieldDescription", comment: "")
        static let fieldWebsite = NSLocalizedString("Profile.EditProfile.fieldWebsite", comment: "")
    }
    
    // MARK: - Validation
    
    enum Validation {
        static let nameEmpty = NSLocalizedString("Profile.Validation.nameEmpty", comment: "")
        static let nameTooShort = NSLocalizedString("Profile.Validation.nameTooShort", comment: "")
        static let nameTooLong = NSLocalizedString("Profile.Validation.nameTooLong", comment: "")
        static let descriptionEmpty = NSLocalizedString("Profile.Validation.descriptionEmpty", comment: "")
        static let descriptionTooLong = NSLocalizedString("Profile.Validation.descriptionTooLong", comment: "")
        static let websiteInvalidFormat = NSLocalizedString("Profile.Validation.websiteInvalidFormat", comment: "")
        static let urlInvalidFormat = NSLocalizedString("Profile.Validation.urlInvalidFormat", comment: "")
        static let urlInvalidScheme = NSLocalizedString("Profile.Validation.urlInvalidScheme", comment: "")
        static let urlInvalidExtension = NSLocalizedString("Profile.Validation.urlInvalidExtension", comment: "")
    }
}
