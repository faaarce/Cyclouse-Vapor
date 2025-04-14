//
//  File.swift
//  Cyclouse
//
//  Created by yoga arie on 22/03/25.
//
// Sources/App/Models/OrderItem.swift
import Fluent
import Vapor

final class OrderItem: Model, Content {
    static let schema = "order_items"
    
    @ID(key: .id)
    var id: UUID?
    
    @Parent(key: "order_id")
    var order: Order
    
    @Parent(key: "product_id")
    var product: Product
    
    @Field(key: "name")
    var name: String
    
    @Field(key: "price")
    var price: Int
    
    @Field(key: "quantity")
    var quantity: Int
    
    @Field(key: "image")
    var image: String
    
    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?
    
    init() {}
    
    init(id: UUID? = nil, orderId: UUID, productId: String, name: String, price: Int, quantity: Int, image: String) {
        self.id = id
        self.$order.id = orderId
        self.$product.id = productId
        self.name = name
        self.price = price
        self.quantity = quantity
        self.image = image
    }
}
