//
//  File.swift
//  Cyclouse
//
//  Created by yoga arie on 29/09/24.
//


import Vapor

struct User: Content {
    let id: UUID
    let email: String
   let phone: String
    let password: String
}

struct LoginRequest: Content {
    let email: String
    let password: String
}

struct LoginResponse: Content {
    let message: String
    let success: Bool
}

struct RegisterRequest: Content {
    let email: String
    let phone: String
    let password: String
    let confirmPassword: String
}

struct RegisterResponse: Content {
    let message: String
    let success: Bool
}

