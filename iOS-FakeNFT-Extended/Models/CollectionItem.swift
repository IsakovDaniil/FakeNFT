//
//  CollectionItem.swift
//  iOS-FakeNFT-Extended
//
//  Created by Владимир Брюковкин on 08.02.2026.
//

import Foundation

struct CollectionItem: Identifiable, Hashable {
    let id: String
    let name: String
    let imageURLs: [URL]
    let nftCount: Int
    /// Для превью и моков: одна картинка из Assets — уже полоска из трёх совмещённых изображений на всю строку.
    var localCoverImageName: String?
    let author: String
    let description: String
    let website: String
}
