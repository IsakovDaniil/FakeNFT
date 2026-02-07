//
//  ProfileAvatar.swift
//  iOS-FakeNFT-Extended
//
//  Created by Даниил on 07.02.2026.
//

import SwiftUI

struct ProfileAvatar: View {
    let image: Image
    
    var body: some View {
        image
            .resizable()
            .scaledToFit()
            .frame(width: 70, height: 70)
            .clipShape(Circle())
    }
}

#Preview {
    ProfileAvatar(image: Image(.placeholderAvatar))
}
