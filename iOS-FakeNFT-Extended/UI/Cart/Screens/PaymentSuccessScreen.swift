//
//  PaymentSuccessScreen.swift
//  iOS-FakeNFT-Extended
//
//  Created by Султан Ахметбек on 11.02.2026.
//

import SwiftUI

struct PaymentSuccessScreen: View {
    @Environment(CartRouter.self) private var router
    
    var body: some View {
        VStack {
            Spacer()
            
            Image(.catPayment)
                .padding(.bottom, 20)
            
            Text(CartLn.paymentSuccessTitle)
                .font(.bold22)
                .multilineTextAlignment(.center)
            
            Spacer()
            
            CartButton(title: CartLn.paymentBackButton) {
                router.popToRoot()
            }
        }
        .padding(.horizontal, 16)
        .background(.appWhite)
    }
}

#Preview {
    PaymentSuccessScreen()
}
