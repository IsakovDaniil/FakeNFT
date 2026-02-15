//
//  CollectionRow.swift
//  iOS-FakeNFT-Extended
//
//  Created by Владимир Брюковкин on 08.02.2026.
//

import Kingfisher
import SwiftUI

// MARK: - View

struct CollectionRow: View {

    let item: CollectionItem

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            coverImage
                .frame(height: 140)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            
            titleBlock
                .frame(height: 22)
            
            Spacer(minLength: 0)
        }
        .frame(height: 179)
        .frame(maxWidth: .infinity, alignment: .topLeading)
    }

    private var coverImage: some View {
        Group {
            if let localName = item.localCoverImageName {
                Image(localName)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } else if let url = item.imageURLs.first {
                KFImage(url)
                    .placeholder {
                        Rectangle()
                            .fill(Color.gray.opacity(0.2))
                    }
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } else {
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
            }
        }
        .frame(maxWidth: .infinity)
        .clipped()
    }

    private var titleBlock: some View {
        HStack(spacing: 4) {
            Text(item.name)
                .font(.bold17)
            Text("(\(item.nftCount))")
                .font(.bold17)
        }
        .foregroundStyle(.primary)
        .frame(maxWidth: .infinity, alignment: .leading)
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
                nftIds: [],
                localCoverImageName: "CataloguePeach",
                author: "John Doe",
                description: "",
                website: ""
            ))
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .padding(.horizontal, 16)
            Spacer()
        }
    }
}
