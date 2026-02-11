//
//  CartCell.swift
//  iOS-FakeNFT-Extended
//
//  Created by Султан Ахметбек on 07.02.2026.
//

import SwiftUI
import Kingfisher
import Combine

struct CartCell: View {
    let viewModel: CartViewModel
    let nft: Nft

    var body: some View {
        HStack(spacing: 20) {
            nftImage

            VStack(alignment: .leading, spacing: 12) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(nft.name)
                        .font(.bold17)

                    ratingView
                }

                VStack(alignment: .leading, spacing: 2) {
                    Text("Цена")
                        .font(.regular13)

                    Text("\(priceText) ETH")
                        .font(.bold17)
                }
            }
            .padding(.vertical, 8)

            Spacer()
            
            Button {
                viewModel.setNftToDelete(nft)
            } label: {
                Image(.cartDelete)
                    .foregroundStyle(.appBlack)
            }
        }
    }

    private var nftImage: some View {
        KFImage(nft.imagesUrls.first)
            .frame(width: 108, height: 108)
            .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    private var ratingView: some View {
        HStack(spacing: 2) {
            ForEach(0..<5, id: \.self) { index in
                Image(.star)
                    .foregroundStyle(index < nft.rating ? Color(.appYellow) : Color(.appLightGray))
            }
        }
    }

    private var priceText: String {
        String(format: "%.2f", nft.price)
            .replacingOccurrences(of: ".", with: ",")
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
    
    CartCell(viewModel: viewModel, nft: NftMock.mockNFT)
        .padding(.horizontal, 16)
}
