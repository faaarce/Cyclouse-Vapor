//
//  File.swift
//  Cyclouse
//
//  Created by yoga arie on 23/03/25.
//

import Vapor

struct AuthResponse: Content {
    let success: Bool
    let message: String
    let userId: String
    
    static func registered(userId: String) -> Self {
        return Self(
            success: true,
            message: "User registered successfully!",
            userId: userId
        )
    }
    
    static func loggedIn(userId: String) -> Self {
        return Self(
            success: true,
            message: "Login successful",
            userId: userId
        )
    }
    
    static func error(_ message: String) -> Self {
        return Self(
            success: false,
            message: message,
            userId: ""
        )
    }
}


struct RegisterResponse: Content {
    let success: Bool
    let message: String
    let userId: String
    
    // Initialize with common values
    static func success(userId: String) -> RegisterResponse {
        return RegisterResponse(
            success: true,
            message: "User registered successfully!",
            userId: userId
        )
    }
}
