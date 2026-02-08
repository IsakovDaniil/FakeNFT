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
    let viewModel: CartViewModel
    
    var body: some View {
        VStack(spacing: 20) {
            if let nft = viewModel.nftToDelete, let imageUrl = nft.images.first {
                KFImage(imageUrl)
                    .frame(width: 108, height: 108)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            
            Text("Вы уверены, что хотите\nудалить объект из корзины?")
                .font(.regular13)
                .multilineTextAlignment(.center)
            
            HStack(spacing: 8) {
                Button {
                    viewModel.closeDeleteView()
                    Task { @MainActor in 
                        await viewModel.removeNFT()
                    }
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
                    viewModel.closeDeleteView()
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
    let services = ServicesAssembly(
        networkClient: DefaultNetworkClient(),
        nftStorage: NftStorageImpl(),
        orderStorage: OrderStorageImpl()
    )
    let vm = CartViewModel(
        nftService: services.nftService,
        orderService: services.orderService
    )
    
    CartDeleteView(viewModel: vm)
}
