//
//  File.swift
//  Cyclouse
//
//  Created by yoga arie on 22/03/25.
//

import Fluent
import Vapor

final class ProductCategory: Model, Content {
    static let schema = "product_categories"
    
    @ID(custom: .id, generatedBy: .user)
    var id: String?
    
    @Field(key: "name")
    var name: String
    
    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?
    
    @Children(for: \.$category)
    var products: [Product]
    
    init() {}
    
    init(id: String, name: String) {
        self.id = id
        self.name = name
    }
}
