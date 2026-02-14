//
//  EditProfileConstants.swift
//  iOS-FakeNFT-Extended
//
//  Created by Даниил on 14.02.2026.
//

import Foundation

enum EditProfileConstants {
    
    // MARK: - Alerts & Dialogs Titles
    
    static let avatarActionSheetTitle = "Фото профиля"
    static let urlAlertTitle = "Ссылка на фото"
    static let exitConfirmationTitle = "Уверены, что хотите выйти?"
    static let errorAlertTitle = "Ошибка"
    
    // MARK: - Buttons & Actions
    
    static let changePhoto = "Изменить фото"
    static let deletePhoto = "Удалить фото"
    static let cancel = "Отмена"
    static let save = "Сохранить"
    static let stay = "Остаться"
    static let exit = "Выйти"
    static let okey = "OK"
    
    // MARK: - TextField Placeholders / Labels
    
    static let urlPlaceholder = "https://example.com/"
    
    // MARK: - Success Messages
    
    static let savedMessage = "Сохранено"
    
    // MARK: - Exit Alert Message
    
    static let unsavedChangesMessage = "Несохранённые изменения будут потеряны"
    
    // MARK: - Error Defaults
    
    static let defaultErrorMessage = "Не удалось сохранить профиль"
    static let profileNotFoundError = "Не удалось найти исходный профиль"
    
    // MARK: - Field Titles
    
    enum FieldTitles {
        static let name = "Имя"
        static let description = "Описание"
        static let website = "Сайт"
    }
    
    // MARK: - Error Messages
    
    enum ErrorMessages {
        static let serverErrorPrefix = "Ошибка сервера: "
        static let connectionError = "Ошибка подключения"
        static let parsingError = "Ошибка обработки данных"
        static let invalidRequestPrefix = "Некорректный запрос: "
        static let networkError = "Ошибка сети"
    }
}
