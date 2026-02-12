import Foundation

enum CartSortType: String, CaseIterable {
    case price
    case rating
    case name

    var title: String {
        switch self {
        case .price: return "cart.sort.type.price"
        case .rating: return "cart.sort.type.rating"
        case .name: return "cart.sort.type.name"
        }
    }
}
