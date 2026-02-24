//
//  ProfileConstants.swift
//  iOS-FakeNFT-Extended
//
//  Created by Даниил on 14.02.2026.
//

import Foundation

enum ProfileConstants {
    
    // MARK: - Navigation
    
    static let navigationTitle = "Профиль"
    
    // MARK: - Alerts
    
    static let errorAlertTitle = "Ошибка"
    static let retryButton = "Повторить"
    static let cancelButton = "Отмена"
    static let defaultErrorMessage = "Не удалось загрузить профиль"
    
    // MARK: - Error Messages
    
    enum ErrorMessages {
        static let serverErrorPrefix = "Ошибка сервера: "
        static let connectionError = "Ошибка подключения"
        static let parsingError = "Ошибка обработки данных"
        static let invalidRequestPrefix = "Некорректный запрос: "
        static let networkError = "Ошибка сети"
    }
    
    // MARK: - Menu
    
    enum Menu {
        static let myNFTTitle = "Мои NFT"
        static let favoriteNFTTitle = "Избранные NFT"
    }
    
    // MARK: - Empty State
    
    enum EmptyState {
        static let myNFT = "У вас ещё нет NFT"
        static let favorite = "У вас ещё нет избранных NFT"
    }
    
    // MARK: - Sort
    
    enum Sort {
        static let byPrice = "По цене"
        static let byRating = "По рейтингу"
        static let byName = "По названию"
    }
    
    // MARK: - My NFT
    
    enum MyNFT {
        static let navigationTitle = "Мои NFT"
        static let sortDialogTitle = "Сортировка"
        static let closeButtonTitle = "Закрыть"
        static let retryButtonTitle = "Повторить"
        static let cancelButtonTitle = "Отмена"
        static let favoriteUpdateErrorMessage = "Не удалось обновить избранное"
    }
    
    // MARK: - Favorite NFT
    
    enum FavoriteNFT {
        static let navigationTitle = "Избранные NFT"
        static let favoriteUpdateErrorMessage = "Не удалось обновить избранное"
    }
    
    // MARK: - Edit Profile
    
    enum EditProfile {
        static let avatarActionSheetTitle = "Фото профиля"
        static let urlAlertTitle = "Ссылка на фото"
        static let exitConfirmationTitle = "Уверены, что хотите выйти?"
        static let changePhoto = "Изменить фото"
        static let deletePhoto = "Удалить фото"
        static let cancel = "Отмена"
        static let save = "Сохранить"
        static let stay = "Остаться"
        static let exit = "Выйти"
        static let okay = "OK"
        static let urlPlaceholder = "https://example.com/"
        static let savedMessage = "Сохранено"
        static let unsavedChangesMessage = "Несохранённые изменения будут потеряны"
        static let defaultErrorMessage = "Не удалось сохранить профиль"
        static let profileNotFoundError = "Не удалось найти исходный профиль"
        static let fieldName = "Имя"
        static let fieldDescription = "Описание"
        static let fieldWebsite = "Сайт"
    }
    
    // MARK: - Validation
    
    enum Validation {
        static let nameEmpty = "Имя не может быть пустым"
        static let nameTooShort = "Имя должно содержать минимум 2 символа"
        static let nameTooLong = "Имя не должно превышать 30 символов"
        static let descriptionEmpty = "Описание не может быть пустым"
        static let descriptionTooLong = "Описание не может быть длиннее 300 символов"
        static let websiteInvalidFormat = "Неверный формат сайта. Пример: example.com"
        static let urlInvalidFormat = "Неверный формат URL"
        static let urlInvalidScheme = "URL должен начинаться с http:// или https://"
        static let urlInvalidExtension = "Поддерживаемые форматы: JPG, PNG, JPEG, WEBP"
    }
}
