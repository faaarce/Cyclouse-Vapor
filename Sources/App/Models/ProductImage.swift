//
//  File.swift
//  Cyclouse
//
//  Created by yoga arie on 22/03/25.
//

// Sources/App/Models/ProductImage.swift
import Fluent
import Vapor

final class ProductImage: Model, Content {
    static let schema = "product_images"
    
    @ID(key: .id)
    var id: UUID?
    
    @Parent(key: "product_id")
    var product: Product
    
    @Field(key: "image_url")
    var imageUrl: String
    
    @Field(key: "display_order")
    var displayOrder: Int
    
    init() {}
    
    init(id: UUID? = nil, productId: String, imageUrl: String, displayOrder: Int = 0) {
        self.id = id
        self.$product.id = productId
        self.imageUrl = imageUrl
        self.displayOrder = displayOrder
    }
}
