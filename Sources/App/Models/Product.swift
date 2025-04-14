//
//  File.swift
//  Cyclouse
//
//  Created by yoga arie on 22/03/25.
//

// Sources/App/Models/Product.swift
import Fluent
import Vapor

final class Product: Model, Content {
    static let schema = "products"
    
    @ID(custom: .id, generatedBy: .user)
    var id: String?
    
    @Parent(key: "category_id")
    var category: ProductCategory
    
    @Field(key: "name")
    var name: String
    
    @Field(key: "description")
    var description: String
    
    @Field(key: "brand")
    var brand: String
    
    @Field(key: "price")
    var price: Int
    
    @Field(key: "quantity")
    var quantity: Int
    
    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?
    
    @Timestamp(key: "updated_at", on: .update)
    var updatedAt: Date?
    
    @Children(for: \.$product)
    var images: [ProductImage]
    
    @Children(for: \.$product)
    var cartItems: [CartItem]
    
    @Children(for: \.$product)
    var orderItems: [OrderItem]
    
    init() {}
    
    init(id: String, categoryId: String, name: String, description: String, brand: String, price: Int, quantity: Int) {
        self.id = id
        self.$category.id = categoryId
        self.name = name
        self.description = description
        self.brand = brand
        self.price = price
        self.quantity = quantity
    }
}
