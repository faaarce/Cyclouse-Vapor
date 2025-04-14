//
//  File.swift
//  Cyclouse
//
//  Created by yoga arie on 22/03/25.
//
// Sources/App/Models/CartItem.swift
import Fluent
import Vapor

final class CartItem: Model, Content {
    static let schema = "cart_items"
    
    @ID(key: .id)
    var id: UUID?
    
    @Parent(key: "cart_id")
    var cart: Cart
    
    @Parent(key: "product_id")
    var product: Product
    
    @Field(key: "quantity")
    var quantity: Int
    
    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?
    
    @Timestamp(key: "updated_at", on: .update)
    var updatedAt: Date?
    
    init() {}
    
    init(id: UUID? = nil, cartId: UUID, productId: String, quantity: Int) {
        self.id = id
        self.$cart.id = cartId
        self.$product.id = productId
        self.quantity = quantity
    }
}
