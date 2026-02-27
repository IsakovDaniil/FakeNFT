import Foundation

enum CartSortType: String, CaseIterable {
    case price
    case rating
    case name

    var title: String {
        switch self {
        case .price: CartLn.cartSortTypePrice
        case .rating: CartLn.cartSortTypeRating
        case .name: CartLn.cartSortTypeName
        }
    }
}
