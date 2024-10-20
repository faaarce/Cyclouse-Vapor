//
//  File.swift
//  Cyclouse
//
//  Created by yoga arie on 08/10/24.
//

import Foundation
import Vapor

class TokenBlacklist {
    static let shared = TokenBlacklist()
    private var invalidatedTokens: Set<String> = []
    
    private init() {}
    
    func invalidateToken(_ token: String) {
        invalidatedTokens.insert(token)
    }
    
    func isTokenInvalid(_ token: String) -> Bool {
        return invalidatedTokens.contains(token)
    }
}

