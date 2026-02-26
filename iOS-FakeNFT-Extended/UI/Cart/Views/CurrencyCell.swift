//
//  CurrencyCell.swift
//  iOS-FakeNFT-Extended
//
//  Created by Султан Ахметбек on 13.02.2026.
//

import SwiftUI
import Kingfisher

struct CurrencyCell: View {
    @Environment(CartViewModel.self) private var viewModel
    let item: Currency
    
    var body: some View {
        HStack(spacing: 4) {
            currencyImage
            
            VStack(alignment: .leading) {
                Text(item.title)
                    .font(.regular13)
                    .foregroundStyle(.appBlack)
                
                Text(item.name)
                    .font(.regular13)
                    .foregroundStyle(.appGreen)
            }
        }
        .padding(.vertical, 5)
        .padding(.horizontal, 12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.appLightGray)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay {
            if viewModel.currencyToPay == item {
                RoundedRectangle(cornerRadius: 12)
                    .stroke(.appBlack, lineWidth: 1)
            }
        }
        .onTapGesture {
            if viewModel.currencyToPay != item {
                viewModel.setCurrency(item)
            } else {
                viewModel.setCurrency(nil)
            }
        }
    }
    
    private var currencyImage: some View {
        KFImage(item.imageUrl)
            .frame(width: 36, height: 36)
            .clipShape(RoundedRectangle(cornerRadius: 6))
    }
}

#Preview {
    CurrencyCell(item: CurrencyMock.mockCurrency)
}
