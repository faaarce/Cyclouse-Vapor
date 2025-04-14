//
//  File.swift
//  Cyclouse
//
//  Created by yoga arie on 22/03/25.
//
// Sources/App/Models/AuthToken.swift
import Fluent
import Vapor


final class AuthToken: Model, Content {
    static let schema = "auth_tokens"
    
    @ID(key: .id)
    var id: UUID?
    
    @Parent(key: "user_id")
    var user: User
    
    @Field(key: "token")
    var token: String
    
    @Field(key: "is_blacklisted")
    var isBlacklisted: Bool
    
    @Field(key: "expires_at")
    var expiresAt: Date
    
    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?
    
    init() {}
    
    init(id: UUID? = nil, userId: UUID, token: String, expiresAt: Date, isBlacklisted: Bool = false) {
        self.id = id
        self.$user.id = userId
        self.token = token
        self.expiresAt = expiresAt
        self.isBlacklisted = isBlacklisted
    }
}
// Sources/App/configure.swift
// Add JWT configuration
//app.jwt.signers.use(.hs256(key: "your-secret-signing-key"))
