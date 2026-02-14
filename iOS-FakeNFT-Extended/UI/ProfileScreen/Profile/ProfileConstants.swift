//
//  ProfileConstants.swift
//  iOS-FakeNFT-Extended
//
//  Created by Даниил on 14.02.2026.
//

import Foundation

enum ProfileConstants {
    
    // MARK: - Alert Titles & Messages
    static let errorAlertTitle = "Ошибка"
    static let retryButton = "Повторить"
    static let cancelButton = "Отмена"
    static let defaultErrorMessage = "Не удалось загрузить профиль"
    
    // MARK: - Menu Items
    enum Menu {
        static let myNFTTitle = "Мои NFT"
        static let favoriteNFTTitle = "Избранные NFT"
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
