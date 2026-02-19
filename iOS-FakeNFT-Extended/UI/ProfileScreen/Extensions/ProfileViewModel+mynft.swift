//
//  ProfileViewModel+mynft.swift
//  iOS-FakeNFT-Extended
//
//  Created by Даниил on 19.02.2026.
//

extension ProfileViewModel {
    func createMyNFTViewModel(servicesAssembly: ServicesAssembly) -> MyNFTViewModel? {
        guard let profile = profile else { return nil }
        
        return MyNFTViewModel(
            service: servicesAssembly.profileMyNFTService,
            profile: profile
        )
    }
}
