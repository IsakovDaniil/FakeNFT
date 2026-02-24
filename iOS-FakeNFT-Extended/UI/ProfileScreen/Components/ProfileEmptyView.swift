//
//  ProfileEmptyView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Даниил on 24.02.2026.
//

import SwiftUI

struct ProfileEmptyView: View {

    // MARK: - Properties

    enum Screen {
        case myNFT
        case favorite

        var text: String {
            switch self {
            case .myNFT: ProfileConstants.EmptyState.myNFT
            case .favorite: ProfileConstants.EmptyState.favorite
            }
        }
    }

    let screen: Screen

    // MARK: - Body

    var body: some View {
        ZStack {
            Color.appWhite.ignoresSafeArea()

            Text(screen.text)
                .font(Font.bold17)
                .foregroundStyle(.appBlack)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

#Preview {
    ProfileEmptyView(screen: .myNFT)
}
