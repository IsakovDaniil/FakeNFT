//
//  DeleteConfirmationView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Султан Ахметбек on 08.02.2026.
//


//
//  DeleteConfirmationView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Султан Ахметбек on 07.02.2026.
//

import SwiftUI
import Kingfisher

struct CartDeleteView: View {
    @Binding var nft: Nft?
    
    var body: some View {
        VStack(spacing: 20) {
            if let nft {
                KFImage(nft.images.first!)
                    .frame(width: 108, height: 108)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            
            Text("Вы уверены, что хотите\nудалить объект из корзины?")
                .font(.regular13)
                .multilineTextAlignment(.center)
            
            HStack(spacing: 8) {
                Button {
                    nft = nil
                } label: {
                    Text("Удалить")
                        .font(.system(size: 17))
                        .foregroundStyle(.red)
                        .frame(minWidth: 127)
                        .frame(height: 44)
                        .background(.appBlack)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                
                Button {
                    nft = nil
                } label: {
                    Text("Вернуться")
                        .font(.system(size: 17))
                        .foregroundStyle(.appWhite)
                        .frame(minWidth: 127)
                        .frame(height: 44)
                        .background(.appBlack)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
            }
            .padding(.horizontal, 16)
        }
    }
}

#Preview {
    CartDeleteView(nft: .constant(.mockNFT))
}
