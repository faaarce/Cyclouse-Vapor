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
    let email: String
    let phone: String
    let name: String
    
    // Method for successful registration response
    static func registered(userId: String, email: String, phone: String, name: String) -> Self {
        return Self(
            success: true,
            message: "User registered successfully!",
            userId: userId,
            email: email,
            phone: phone,
            name: name
        )
    }
    
    // Method for successful login response
    static func loggedIn(userId: String, email: String, phone: String, name: String) -> Self {
        return Self(
            success: true,
            message: "Login successful",
            userId: userId,
            email: email,
            phone: phone,
            name: name
        )
    }
    
    // Method for error response
    static func error(_ message: String) -> Self {
        return Self(
            success: false,
            message: message,
            userId: "",
            email: "",
            phone: "",
            name: ""
        )
    }
}

struct RegisterResponse: Content {
    let success: Bool
    let message: String
    let userId: String
    let email: String
    let phone: String
    let name: String
    
    // Initialize with common values for success response
    static func success(userId: String, email: String, phone: String, name: String) -> RegisterResponse {
        return RegisterResponse(
            success: true,
            message: "User registered successfully!",
            userId: userId,
            email: email,
            phone: phone,
            name: name
        )
    }
}
