import Foundation

struct Nft: Decodable, Equatable {
    let id: String
    let name: String
    let imagesUrls: [URL]
    let rating: Int
    let description: String
    let price: Float
    let author: String
    let website: String

    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case imagesUrls = "images"
        case rating
        case description
        case price
        case author
        case website
    }
}
