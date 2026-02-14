//
//  ProfileAvatar.swift
//  iOS-FakeNFT-Extended
//
//  Created by Даниил on 07.02.2026.
//

import SwiftUI
import Kingfisher

struct ProfileAvatar: View {
    let urlString: String?
    let editMode: Bool
    var onTap: (() -> Void)?
    
    private let size: CGFloat = 70
    
    private var url: URL? {
        guard let urlString else { return nil }
        
        if urlString.hasPrefix("http") {
            return URL(string: urlString)
        } else {
            return URL(string: "https://\(urlString)")
        }
    }
    
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
    
    @ViewBuilder
    private var avatarView: some View {
        if let url {
            KFImage(url)
                .resizable()
                .placeholder {
                    placeholderView
                }
                .onFailure { _ in }
                .scaledToFill()
                .frame(width: size, height: size)
                .clipShape(Circle())
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
