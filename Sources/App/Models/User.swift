//
//  File.swift
//  Cyclouse
//
//  Created by yoga arie on 29/09/24.
//

import Fluent
import Vapor
import FluentPostgresDriver

final class User: Model, Content {
    static let schema = "users"
    
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
    
    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?
    
    @Timestamp(key: "updated_at", on: .update)
    var updatedAt: Date?
    
    @Children(for: \.$user)
    var authTokens: [AuthToken]
    
    @Children(for: \.$user)
    var orders: [Order]
    
    @Children(for: \.$user)
    var cart: [Cart]
    
    init() {}
    
    init(id: UUID? = nil, name: String, email: String, phone: String, password: String) {
        self.id = id
        self.name = name
        self.email = email
        self.phone = phone
        self.password = password
    }
}
