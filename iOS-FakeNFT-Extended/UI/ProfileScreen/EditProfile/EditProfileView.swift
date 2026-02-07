//
//  EditProfileView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Даниил on 07.02.2026.
//

import SwiftUI

struct EditProfileView: View {
    var body: some View {
        VStack {
            ProfileAvatar(image: Image(.placeholderAvatar))
            EditProfileButton(name: "Сохранить") {
                print("tap")
            }
        }
    }
}

#Preview {
    EditProfileView()
}
