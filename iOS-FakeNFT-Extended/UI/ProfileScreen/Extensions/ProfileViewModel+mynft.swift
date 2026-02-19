//
//  ProfileViewModel+mynft.swift
//  iOS-FakeNFT-Extended
//
//  Created by Даниил on 19.02.2026.
//

extension ProfileViewModel {
    func createMyNFTViewModel() -> MyNFTViewModel? {
        guard let profile = profile else { return nil }
        
        let networkClient = DefaultNetworkClient()
        let service = ProfileMyNFTService(networkClient: networkClient)
        
        return MyNFTViewModel(service: service, profile: profile)
    }
}
