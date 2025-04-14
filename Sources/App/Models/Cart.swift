//
//  File.swift
//  Cyclouse
//
//  Created by yoga arie on 22/03/25.
//
// Sources/App/Models/Cart.swift
import Fluent
import Vapor

final class Cart: Model, Content {
    static let schema = "carts"
    
    @ID(key: .id)
    var id: UUID?
    
    @Parent(key: "user_id")
    var user: User
    
    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?
    
    @Timestamp(key: "updated_at", on: .update)
    var updatedAt: Date?
    
    @Children(for: \.$cart)
    var items: [CartItem]
    
    init() {}
    
    init(id: UUID? = nil, userId: UUID) {
        self.id = id
        self.$user.id = userId
    }
}
