//
//  ProfileView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Даниил on 07.02.2026.
//

import SwiftUI

struct ProfileView: View {
    
    // MARK: - Properties
    
    // MARK: - Body
    
    var body: some View {
        ZStack {
            Color.appWhite
                .ignoresSafeArea()
            VStack {
                avatarNameSection
            }
        }
    }
    
    // MARK: - View Components
    private var avatarNameSection: some View {
        HStack(spacing: 16) {
            ProfileAvatar(image: Image(.placeholderAvatar))
            
            Text("Joaquin Phoenix")
                .font(Font.bold22)
                .foregroundStyle(.appBlack)
            
        }
    }
}

#Preview {
    ProfileView()
}
