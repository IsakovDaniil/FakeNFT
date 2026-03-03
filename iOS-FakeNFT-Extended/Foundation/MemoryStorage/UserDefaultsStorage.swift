//
//  UserDefaultsStorage.swift
//  iOS-FakeNFT-Extended
//
//  Created by Даниил on 20.02.2026.
//

import Foundation

final class UserDefaultsStorage {
    
    private let userDefaults: UserDefaults
    private let encoder: JSONEncoder
    private let decoder: JSONDecoder
    
    init(
        userDefaults: UserDefaults = .standard,
        encoder: JSONEncoder = JSONEncoder(),
        decoder: JSONDecoder = JSONDecoder()
    ) {
        self.userDefaults = userDefaults
        self.encoder = encoder
        self.decoder = decoder
    }
    
    func save<T: Encodable>(_ value: T, forKey key: String) {
        guard let data = try? encoder.encode(value) else { return }
        userDefaults.set(data, forKey: key)
    }
    
    func load<T: Decodable>(forKey key: String) -> T? {
        guard let data = userDefaults.data(forKey: key),
              let value = try? decoder.decode(T.self, from: data) else { return nil }
        return value
    }
    
    func remove(forKey key: String) {
        userDefaults.removeObject(forKey: key)
    }
}
