//
//  ProfileView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Даниил on 07.02.2026.
//

import SwiftUI

struct ProfileView: View {
    
    // MARK: - Properties
    var userName: String
    var bio: String
    var website: String
    
    // MARK: - Body
    
    var body: some View {
        ZStack {
            Color.appWhite
                .ignoresSafeArea()
            VStack(alignment: .leading, spacing: 20) {
                avatarNameSection
                
                bioSection
            }
        }
        .padding()
    }
    
    // MARK: - View Components
    private var avatarNameSection: some View {
        HStack(spacing: 16) {
            ProfileAvatar(image: Image(.placeholderAvatar))
            
            Text(userName)
                .font(Font.bold22)
                .foregroundStyle(.appBlack)
        }
    }
    
    private var bioSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(bio)
                .font(Font.regular13)
            
            if let url = URL(string: "https://\(website)") {
                Link(website, destination: url)
                    .font(Font.regular15)
                    .foregroundStyle(.appBlue)
            }
        }
    }
}

#Preview {
    ProfileView(userName: "Joaquin Phoenix", bio: "Дизайнер из Казани, люблю цифровое искусство  и бейглы. В моей коллекции уже 100+ NFT,  и еще больше — на моём сайте. Открыт к коллаборациям.", website: "JoaquinPhoenix.com")
}
