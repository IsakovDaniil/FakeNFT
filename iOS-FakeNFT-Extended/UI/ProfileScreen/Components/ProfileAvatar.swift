//
//  ProfileAvatar.swift
//  iOS-FakeNFT-Extended
//
//  Created by Даниил on 07.02.2026.
//

import SwiftUI

struct ProfileAvatar: View {
    let image: Image
    let editMode: Bool
    var onTap: (() -> Void)?
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            image
                .resizable()
                .scaledToFit()
                .frame(width: 70, height: 70)
                .clipShape(Circle())
            
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
}

#Preview {
    VStack(spacing: 20) {
        ProfileAvatar(
            image: Image(.placeholderAvatar),
            editMode: true,
            onTap: { print("Avatar tapped") }
        )
        
        ProfileAvatar(
            image: Image(.placeholderAvatar),
            editMode: false
        )
    }
}
