//
//  DeleteConfirmationView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Султан Ахметбек on 08.02.2026.
//

import SwiftUI
import Kingfisher

struct CartDeleteView: View {
    let viewModel: CartViewModel
    
    var body: some View {
        VStack(spacing: 20) {
            if let nft = viewModel.nftToDelete, let imageUrl = nft.imagesUrls.first {
                KFImage(imageUrl)
                    .frame(width: 108, height: 108)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            
            Text("cart.confirm.delete")
                .font(.regular13)
                .multilineTextAlignment(.center)
            
            HStack(spacing: 8) {
                CartDeleteButton(title: "cart.delete.button", color: .red) {
                    Task {
                        await viewModel.removeNFT()
                    }
                }
                
                CartDeleteButton(title: "cart.back.button", color: .appWhite) {
                    viewModel.closeDeleteView()
                }
            }
            .padding(.horizontal, 16)
        }
    }
}

private struct CartDeleteButton: View {
    let title: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(LocalizedStringKey(title))
                .font(.system(size: 17))
                .foregroundStyle(color)
                .frame(minWidth: 127)
                .frame(height: 44)
                .background(.appBlack)
                .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }
}

#Preview {
    let services = ServicesAssembly(
        networkClient: DefaultNetworkClient(),
        nftStorage: NftStorageImpl(),
        orderStorage: OrderStorageImpl()
    )
    let viewModel = CartViewModel(
        nftService: services.nftService,
        orderService: services.orderService
    )
    
    CartDeleteView(viewModel: viewModel)
}

