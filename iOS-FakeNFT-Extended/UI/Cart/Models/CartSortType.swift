import Foundation

enum CartSortType: String, CaseIterable {
    case price
    case rating
    case name

    var title: String {
        switch self {
        case .price: return CartLn.cartSortTypePrice
        case .rating: return CartLn.cartSortTypeRating
        case .name: return CartLn.cartSortTypeName
        }
    }
}
