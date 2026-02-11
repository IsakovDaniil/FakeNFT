import Foundation

enum CartSortType: String, CaseIterable {
    case price
    case rating
    case name

    var title: String {
        switch self {
        case .price: return "По цене"
        case .rating: return "По рейтингу"
        case .name: return "По названию"
        }
    }
}
