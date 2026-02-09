//
//  ProfileErrorView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Даниил on 09.02.2026.
//

import SwiftUI

struct ProfileErrorView: View {
    let message: String
    let retryAction: () async -> Void
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    ProfileErrorView(
        message: "Не удалось загрузить профиль. Проверьте подключение к интернету.",
        retryAction: {
            print("Retry tapped")
        }
    )
}
