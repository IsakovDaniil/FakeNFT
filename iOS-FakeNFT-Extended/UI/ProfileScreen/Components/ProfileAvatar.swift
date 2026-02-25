//
//  ProfileAvatar.swift
//  iOS-FakeNFT-Extended
//
//  Created by Даниил on 07.02.2026.
//

import SwiftUI

struct ProfileAvatar: View {

    // MARK: - Properties

    let urlString: String?
    let editMode: Bool
    var onTap: (() -> Void)?

    private let size: CGFloat = 70

    private var url: URL? {
        guard let urlString else { return nil }
        return URL(string: urlString.hasPrefix("http") ? urlString : "https://\(urlString)")
    }

    // MARK: - Body

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            avatarView

            if editMode {
                Image(.camera)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 23, height: 23)
            }
        }
        .onTapGesture {
            if editMode {
                onTap?()
            }
        }
    }

    // MARK: - Subviews

    @ViewBuilder
    private var avatarView: some View {
        AsyncImage(url: url) { phase in
            switch phase {
            case .empty:
                placeholderView
            case .success(let image):
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: size, height: size)
                    .clipShape(Circle())
            case .failure:
                placeholderView
            @unknown default:
                placeholderView
            }
        }
    }

    private var placeholderView: some View {
        Image(.placeholderAvatar)
            .resizable()
            .scaledToFill()
            .frame(width: size, height: size)
            .clipShape(Circle())
    }
}

// MARK: - Preview

#Preview {
    VStack(spacing: 20) {
        ProfileAvatar(
            urlString: "https://i.pravatar.cc/300",
            editMode: true,
            onTap: { print("Tap") }
        )

        ProfileAvatar(
            urlString: nil,
            editMode: false
        )

        ProfileAvatar(
            urlString: "https://picsum.photos/200",
            editMode: true
        )
    }
    .padding()
}
