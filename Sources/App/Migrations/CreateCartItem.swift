//
//  File.swift
//  Cyclouse
//
//  Created by yoga arie on 22/03/25.
//
// Sources/App/Migrations/CreateCartItem.swift
import Fluent

struct CreateCartItem: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("cart_items")
            .id()
            .field("cart_id", .uuid, .required, .references("carts", "id", onDelete: .cascade))
            .field("product_id", .string, .required, .references("products", "id", onDelete: .cascade))
            .field("quantity", .int, .required)
            .field("created_at", .datetime)
            .field("updated_at", .datetime)
            .unique(on: "cart_id", "product_id")
            .create()
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("cart_items").delete()
    }
}
