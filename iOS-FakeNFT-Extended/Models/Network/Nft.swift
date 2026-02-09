import Foundation

struct Nft: Decodable, Equatable {
    let id: String
    let name: String
    let images: [URL]
    let rating: Int
    let description: String
    let price: Float
    let author: String
    let website: String
}

extension Nft {
    static var mockNFT: Nft {
        Nft(
            id: "a06d0075-d1a7-40dc-b710-db6808c28cca",
            name: "morbi vel habeo",
            images: [
                URL(filePath: "https://code.s3.yandex.net/Mobile/iOS/NFT/Peach/Biscuit/1.png")!,
                URL(filePath: "https://code.s3.yandex.net/Mobile/iOS/NFT/Peach/Biscuit/2.png")!,
                URL(filePath: "https://code.s3.yandex.net/Mobile/iOS/NFT/Peach/Biscuit/3.png")!
            ],
            rating: 1,
            description: "affert moderatius eloquentiam magna tellus scripserit",
            price: 21.63,
            author: "Author Name",
            website: "https://focused_galileo.fakenfts.org/"
        )
    }
    
    static let mockNFTs: [Nft] = [
        Nft(
            id: "1464520d-1659-4055-8a79-4593b9569e48",
            name: "dico eleifend",
            images: [
                URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Yellow/Helga/1.png")!,
                URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Yellow/Helga/2.png")!,
                URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Yellow/Helga/3.png")!,
            ],
            rating: 5,
            description: "tritani appareat constituam deterruisset justo",
            price: 8.08,
            author: "Quizzical Blackwell",
            website: "https://quizzical_blackwell.fakenfts.org/"
        ),

        Nft(
            id: "739e293c-1067-43e5-8f1d-4377e744ddde",
            name: "commodo porttitor",
            images: [
                URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Beige/April/1.png")!,
                URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Beige/April/2.png")!,
                URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Beige/April/3.png")!,
            ],
            rating: 3,
            description: "fringilla eam vim sonet faucibus impetus",
            price: 36.54,
            author: "Condescending Almeida",
            website: "https://condescending_almeida.fakenfts.org/"
        ),

        Nft(
            id: "5093c01d-e79e-4281-96f1-76db5880ba70",
            name: "eleifend mutat",
            images: [
                URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Gray/Kaydan/1.png")!,
                URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Gray/Kaydan/2.png")!,
                URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Gray/Kaydan/3.png")!,
            ],
            rating: 2,
            description: "tacimates docendi efficitur tempus non quod cras pellentesque commune",
            price: 16.95,
            author: "Goofy Napier",
            website: "https://goofy_napier.fakenfts.org/"
        ),

        Nft(
            id: "b3907b86-37c4-4e15-95bc-7f8147a9a660",
            name: "mel novum",
            images: [
                URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/White/Lumpy/1.png")!,
                URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/White/Lumpy/2.png")!,
                URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/White/Lumpy/3.png")!,
            ],
            rating: 4,
            description: "suspendisse atomorum sumo erroribus instructior etiam",
            price: 49.77,
            author: "Hardcore Archimedes",
            website: "https://hardcore_archimedes.fakenfts.org/"
        ),

        Nft(
            id: "a06d0075-d1a7-40dc-b710-db6808c28cca",
            name: "morbi vel habeo",
            images: [
                URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Peach/Biscuit/1.png")!,
                URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Peach/Biscuit/2.png")!,
                URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Peach/Biscuit/3.png")!,
            ],
            rating: 1,
            description: "affert moderatius eloquentiam magna tellus scripserit",
            price: 21.63,
            author: "Focused Galileo",
            website: "https://focused_galileo.fakenfts.org/"
        ),

        Nft(
            id: "fa03574c-9067-45ad-9379-e3ed2d70df78",
            name: "ei hac",
            images: [
                URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/White/Paddy/1.png")!,
                URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/White/Paddy/2.png")!,
                URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/White/Paddy/3.png")!,
            ],
            rating: 2,
            description: "fusce sit in quis definitionem sem noster sollicitudin",
            price: 47.02,
            author: "Hardcore Robinson",
            website: "https://hardcore_robinson.fakenfts.org/"
        ),

        Nft(
            id: "c14cf3bc-7470-4eec-8a42-5eaa65f4053c",
            name: "recteque fabellas",
            images: [
                URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Beige/Ellsa/1.png")!,
                URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Beige/Ellsa/2.png")!,
                URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Beige/Ellsa/3.png")!,
            ],
            rating: 3,
            description: "eloquentiam deterruisset tractatos repudiandae nunc a electram",
            price: 39.37,
            author: "Priceless Leavitt",
            website: "https://priceless_leavitt.fakenfts.org/"
        ),

        Nft(
            id: "1ce4f491-877d-48d0-9428-0e0129a80ec9",
            name: "lacus auctor tacimates",
            images: [
                URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Pink/Cashew/1.png")!,
                URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Pink/Cashew/2.png")!,
                URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Pink/Cashew/3.png")!,
            ],
            rating: 2,
            description: "proin error in eirmod laoreet quidam",
            price: 26.71,
            author: "Laughing Elgamal",
            website: "https://laughing_elgamal.fakenfts.org/"
        ),

        Nft(
            id: "7dc60644-d3cd-4cf9-9854-f5293ebe93f7",
            name: "habitant curabitur vidisse",
            images: [
                URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Blue/Loki/1.png")!,
                URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Blue/Loki/2.png")!,
                URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Blue/Loki/3.png")!,
            ],
            rating: 1,
            description: "tacimates prompta suspendisse scelerisque qui iisque",
            price: 28.51,
            author: "Heuristic Cray",
            website: "https://heuristic_cray.fakenfts.org/"
        ),

        Nft(
            id: "a4edeccd-ad7c-4c7f-b09e-6edec02a812b",
            name: "mutat nisl",
            images: [
                URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Peach/Nacho/1.png")!,
                URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Peach/Nacho/2.png")!,
                URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Peach/Nacho/3.png")!,
            ],
            rating: 1,
            description: "animal solet pharetra perpetua usu alienum",
            price: 43.53,
            author: "Strange Gates",
            website: "https://strange_gates.fakenfts.org/"
        )
    ]
}
