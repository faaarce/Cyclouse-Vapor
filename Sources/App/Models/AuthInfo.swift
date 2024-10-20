//
//  File.swift
//  Cyclouse
//
//  Created by yoga arie on 29/09/24.
//
import Vapor
import Foundation

struct AuthInfo: Content, Authenticatable {
    let userId: UUID
    let expires: Date
    let email: String
}

// Modified
struct APIResponse<T: Content>: Content {
    let success: Bool
    let message: String
    let data: T?
}

