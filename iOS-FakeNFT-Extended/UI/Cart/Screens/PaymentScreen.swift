//
//  PaymentScreen.swift
//  iOS-FakeNFT-Extended
//
//  Created by Султан Ахметбек on 13.02.2026.
//

import SwiftUI
import ProgressHUD

struct PaymentScreen: View {
    @Environment(CartRouter.self) private var router
    @Environment(CartViewModel.self) private var viewModel
    @Environment(\.dismiss) private var dismiss
    private let urlString = "https://yandex.ru/legal/practicum_termsofuse/ru/"
    
    private let columns = [
        GridItem(.flexible(), spacing: 7),
        GridItem(.flexible(), spacing: 7)
    ]

    var body: some View {
        @Bindable var viewModel = viewModel
        
        VStack {
            LazyVGrid(columns: columns, spacing: 7) {
                ForEach(viewModel.currencies) { currency in
                    CurrencyCell(item: currency)
                }
            }
            .padding(.horizontal, 16)
            
            Spacer()
            
            VStack(alignment: .leading) {
                Text(CartLn.cartPaymentAgreementTitle)
                    .font(.regular13)
                    .foregroundStyle(.appBlack)
                    .padding(.bottom, 2)
                
                NavigationLink {
                    if let url = URL(string: urlString) {
                        WebView(url: url)
                    }
                } label: {
                    Text(CartLn.cartPaymentAgreement)
                        .font(.regular13)
                        .foregroundStyle(.appBlue)
                }
                .padding(.bottom, 16)

                CartButton(title: CartLn.cartPayment) {
                    Task {
                        await viewModel.makePayment()
                    }
                }
                .disabled(viewModel.currencyToPay == nil)
            }
            .padding(16)
            .background(.appLightGray)
            .clipShape(UnevenRoundedRectangle(topLeadingRadius: 12, topTrailingRadius: 12))
        }
        .background(.appWhite)
        .navigationTitle(CartLn.cartPaymentTitle)
        .task {
            await viewModel.loadCurrencies()
        }
        .alert(item: $viewModel.errorWrapper) { error in
            Alert(
                title: Text(error.message),
                primaryButton: .default(Text(CartLn.errorRepeat)) {
                    error.retry?()
                },
                secondaryButton: .cancel(Text(CartLn.cancel))
            )
        }
        .onChange(of: viewModel.state) { _, newValue in
            switch newValue {
            case .idle, .loading:
                ProgressHUD.animate()
            case .data, .error:
                ProgressHUD.dismiss()
            case .checkoutSuccess:
                ProgressHUD.dismiss()
                router.push(.paymentSuccess)
            }
        }
    }
}

#Preview {
    let services = ServicesAssembly(
        networkClient: DefaultNetworkClient(),
        nftStorage: NftStorageImpl(),
        orderStorage: OrderStorageImpl(),
        profileStorage: ProfileStorage()
    )
    let viewModel = CartViewModel(
        nftService: services.nftService,
        orderService: services.orderService
    )
    
    PaymentScreen()
        .environment(viewModel)
}
