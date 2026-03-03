//
//  ErrorWrapper.swift
//  iOS-FakeNFT-Extended
//
//  Created by Султан Ахметбек on 14.02.2026.
//

import Foundation

struct ErrorWrapper: Identifiable {
    let id = UUID()
    let message: String
    let retry: (() -> Void)?
    
    init(_ message: String, retry: (() -> Void)? = nil) {
        self.message = message
        self.retry = retry
    }
    
    init(error: Error, retry: (() -> Void)? = nil) {
        self.message = error.localizedDescription
        self.retry = retry
    }
}
