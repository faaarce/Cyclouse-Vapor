//
//  File.swift
//  Cyclouse
//
//  Created by yoga arie on 29/09/24.
//

import Fluent
import Vapor

final class User: Model, Content {
    static let schema = "users"  // This will be your table name
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "name")
    var name: String
    
    @Field(key: "email")
    var email: String
    
    @Field(key: "phone")
    var phone: String
    
    @Field(key: "password")
    var password: String
    
    init() {}
    
    init(id: UUID? = nil, name: String, email: String, phone: String, password: String) {
        self.id = id
        self.name = name
        self.email = email
        self.phone = phone
        self.password = password
    }
}

struct LoginRequest: Content {
    let email: String
    let password: String
}

struct LoginResponse: Content {
    let message: String
    let success: Bool
  let userId: UUID
  let name: String
  let email: String
  let phone: String
}

struct RegisterRequest: Content {
  let name: String
    let email: String
    let phone: String
    let password: String
    let confirmPassword: String
}

struct RegisterResponse: Content {
    let message: String
    let success: Bool
  let userId: UUID
}

