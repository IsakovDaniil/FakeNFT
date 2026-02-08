import Foundation

struct Nft: Decodable {
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
    
    static var mockNFTs: [Nft] = [
        Nft(
            id: "a06d0075-d1a7-40dc-b710-db6808c28cca",
            name: "Cosmic Dreams",
            images: [
                URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Yellow/Helga/1.png")!,
                URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Yellow/Helga/1.png")!,
                URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Yellow/Helga/1.png")!,
            ],
            rating: 5,
            description: "A breathtaking journey through the stars",
            price: 12.45,
            author: "StarGazer",
            website: "https://cosmic_dreams.fakenfts.org/"
        ),
        Nft(
            id: "b17e1186-e2b8-51ed-c821-ef7919d39ddb",
            name: "Digital Sunset",
            images: [
                URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Yellow/Helga/1.png")!,
                URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Yellow/Helga/1.png")!,
                URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Yellow/Helga/1.png")!,
            ],
            rating: 4,
            description: "Vibrant colors of the evening sky",
            price: 8.99,
            author: "SunsetArtist",
            website: "https://digital_sunset.fakenfts.org/"
        ),
        Nft(
            id: "c28f2297-f3c9-62fe-d932-fg8020e40eec",
            name: "Neon City",
            images: [
                URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Yellow/Helga/1.png")!,
                URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Yellow/Helga/1.png")!,
                URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Yellow/Helga/1.png")!,
            ],
            rating: 5,
            description: "Futuristic urban landscape at night",
            price: 25.50,
            author: "CyberPunk",
            website: "https://neon_city.fakenfts.org/"
        ),
        Nft(
            id: "d39g3308-g4d0-73gf-e043-gh9131f51ffd",
            name: "Ocean Waves",
            images: [
                URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Yellow/Helga/1.png")!,
                URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Yellow/Helga/1.png")!,
                URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Yellow/Helga/1.png")!,
            ],
            rating: 3,
            description: "Serene waves crashing on the shore",
            price: 15.75,
            author: "SeaLover",
            website: "https://ocean_waves.fakenfts.org/"
        ),
        Nft(
            id: "e40h4419-h5e1-84hg-f154-hi0242g62gge",
            name: "Abstract Minds",
            images: [
                URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Yellow/Helga/1.png")!,
                URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Yellow/Helga/1.png")!,
                URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Yellow/Helga/1.png")!,
            ],
            rating: 4,
            description: "Exploration of consciousness and creativity",
            price: 19.20,
            author: "MindBender",
            website: "https://abstract_minds.fakenfts.org/"
        ),
        Nft(
            id: "f51i5520-i6f2-95ih-g265-ij1353h73hhf",
            name: "Mountain Peak",
            images: [
                URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Yellow/Helga/1.png")!,
                URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Yellow/Helga/1.png")!,
                URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Yellow/Helga/1.png")!,
            ],
            rating: 5,
            description: "Majestic mountain summit at dawn",
            price: 32.10,
            author: "AlpineExplorer",
            website: "https://mountain_peak.fakenfts.org/"
        ),
        Nft(
            id: "g62j6631-j7g3-06ji-h376-jk2464i84iig",
            name: "Forest Whispers",
            images: [
                URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Yellow/Helga/1.png")!,
                URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Yellow/Helga/1.png")!,
                URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Yellow/Helga/1.png")!,
            ],
            rating: 2,
            description: "Mysterious sounds of the ancient forest",
            price: 6.50,
            author: "NatureGuide",
            website: "https://forest_whispers.fakenfts.org/"
        ),
        Nft(
            id: "h73k7742-k8h4-17kj-i487-kl3575j95jjh",
            name: "Retro Vibes",
            images: [
                URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Yellow/Helga/1.png")!,
                URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Yellow/Helga/1.png")!,
                URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Yellow/Helga/1.png")!,
            ],
            rating: 4,
            description: "Nostalgic journey to the 80s",
            price: 11.80,
            author: "RetroWave",
            website: "https://retro_vibes.fakenfts.org/"
        ),
        Nft(
            id: "i84l8853-l9i5-28lk-j598-lm4686k06kkj",
            name: "Space Station",
            images: [
                URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Yellow/Helga/1.png")!,
                URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Yellow/Helga/1.png")!,
                URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Yellow/Helga/1.png")!,
            ],
            rating: 5,
            description: "Life aboard an orbital outpost",
            price: 45.00,
            author: "AstroNaut",
            website: "https://space_station.fakenfts.org/"
        ),
        Nft(
            id: "j95m9964-m0j6-39ml-k609-mn5797l17llk",
            name: "Desert Mirage",
            images: [
                URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Yellow/Helga/1.png")!,
                URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Yellow/Helga/1.png")!,
                URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Yellow/Helga/1.png")!,
            ],
            rating: 3,
            description: "Illusions in the endless sands",
            price: 9.30,
            author: "DesertWanderer",
            website: "https://desert_mirage.fakenfts.org/"
        )
    ]
}
