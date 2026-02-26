//
//  CartRoute.swift
//  iOS-FakeNFT-Extended
//
//  Created by Султан Ахметбек on 24.02.2026.
//
import SwiftUI

enum CartRoute: Hashable {
    case payment
    case paymentSuccess
}

@Observable
final class CartRouter {
    var path = NavigationPath()

    func push(_ route: CartRoute) {
        path.append(route)
    }

    func pop() {
        path.removeLast()
    }

    func popToRoot() {
        path.removeLast(path.count)
    }
}
