//
//  ProfileView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Даниил on 07.02.2026.
//

import SwiftUI

struct ProfileView: View {
    
    // MARK: - Body
    
    var body: some View {
        ZStack {
            Color.appWhite
                .ignoresSafeArea()
            HStack {
                avatar
            }
        }
    }
    
    // MARK: - View Components
}

#Preview {
    ProfileView()
}
