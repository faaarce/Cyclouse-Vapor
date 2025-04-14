//
//  File.swift
//  Cyclouse
//
//  Created by yoga arie on 22/03/25.
//
// Sources/App/Migrations/CreateProductImage.swift
import Fluent

struct CreateProductImage: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("product_images")
            .id()
            .field("product_id", .string, .required, .references("products", "id", onDelete: .cascade))
            .field("image_url", .string, .required)
            .field("display_order", .int, .required, .sql(.default(0)))
            .create()
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("product_images").delete()
    }
}
