//
//  CollectionRow.swift
//  iOS-FakeNFT-Extended
//
//  Created by Владимир Брюковкин on 08.02.2026.
//

import Kingfisher
import SwiftUI

// MARK: - Model

struct CollectionItem: Identifiable, Hashable {
    let id: String
    let name: String
    let imageURLs: [URL]
    let nftCount: Int
    /// Для превью и моков: одна картинка из Assets — уже полоска из трёх совмещённых изображений на всю строку.
    var localCoverImageName: String?
}

// MARK: - View

struct CollectionRow: View {

    let item: CollectionItem

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            imageBlock
            textBlock
        }
        .frame(height: 179, alignment: .top)
        .frame(maxWidth: .infinity, alignment: .leading)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    private var imageBlock: some View {
        coverView
            .frame(height: 140)
            .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    private var coverView: some View {
        Group {
            if let name = item.localCoverImageName {
                localCover(name: name)
            } else {
                let urls = imageURLsForDisplay
                if urls.count >= 3 {
                    remoteCover(urls: urls)
                }
            }
        }
    }

    private func localCover(name: String) -> some View {
        Image(name)
            .resizable()
            .scaledToFill()
            .frame(maxWidth: .infinity, maxHeight: 140)
            .clipped()
    }

    private func remoteCover(urls: [URL]) -> some View {
        HStack(spacing: 0) {
            urlImageCell(url: urls[0])
            urlImageCell(url: urls[1])
            urlImageCell(url: urls[2])
        }
    }

    private func urlImageCell(url: URL) -> some View {
        KFImage(url)
            .placeholder {
                Color.gray.opacity(0.2)
            }
            .onFailure { _ in
                // Fallback при ошибке загрузки — placeholder уже показан
            }
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(maxWidth: .infinity, maxHeight: 140)
            .clipped()
    }

    private var textBlock: some View {
        HStack(spacing: 4) {
            Text(item.name)
                .font(.bold17)
            Text("(\(item.nftCount))")
                .font(.bold17)
        }
        .foregroundStyle(.primary)
        .frame(height: 22)
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    /// Ровно 3 URL для отображения (повторяем последний при нехватке).
    private var imageURLsForDisplay: [URL] {
        let urls = item.imageURLs
        guard !urls.isEmpty else { return [] }
        if urls.count >= 3 {
            return Array(urls.prefix(3))
        }
        return urls + Array(repeating: urls.last!, count: 3 - urls.count)
    }
}

// MARK: - Preview

#Preview {
    ZStack {
        Color(white: 0.92)
            .ignoresSafeArea()
        VStack {
            Spacer()
            CollectionRow(item: CollectionItem(
                id: "1",
                name: "Peach",
                imageURLs: [],
                nftCount: 11,
                localCoverImageName: "CataloguePeach"
            ))
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .padding(.horizontal, 16)
            Spacer()
        }
    }
}
