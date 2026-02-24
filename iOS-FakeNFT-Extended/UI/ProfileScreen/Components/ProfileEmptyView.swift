//
//  ProfileEmtyView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Даниил on 24.02.2026.
//

import SwiftUI

struct ProfileEmptyView: View {
    
    // MARK: - Properties
    
    let title: NameScreen
    
    enum NameScreen {
        case myNFt
        case favorite
        
        var text: String {
            switch self {
            case .myNFt: return "У Вас еще нет NFT"
            case .favorite: return "У вас еще нет избранных NFT"
            }
        }
    }
    
    // MARK: - Body
    
    var body: some View {
        ZStack {
            Color.appWhite.ignoresSafeArea()
            
            Text(title.text)
                .font(Font.bold17)
                .foregroundStyle(.appBlack)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

#Preview {
    ProfileEmptyView(title: .myNFt)
}
