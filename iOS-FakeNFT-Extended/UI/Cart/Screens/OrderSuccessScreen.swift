//
//  PaymentSuccessScreen.swift
//  iOS-FakeNFT-Extended
//
//  Created by Султан Ахметбек on 11.02.2026.
//

import SwiftUI

struct OrderSuccessScreen: View {
    var body: some View {
        VStack {
            Spacer()
            
            Image(.catPayment)
                .padding(.bottom, 20)
            
            Text("Успех! Оплата прошла, поздравляем с покупкой!")
                .font(.bold22)
                .multilineTextAlignment(.center)
            
            Spacer()
            
            CartButton(title: "Вернуться в корзину") {
                
            }
        }
        .padding(.horizontal, 16)
        .background(.appWhite)
    }
}

#Preview {
    OrderSuccessScreen()
}
