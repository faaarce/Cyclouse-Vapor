//
//  File.swift
//  Cyclouse
//
//  Created by yoga arie on 22/03/25.
//
// Sources/App/Migrations/CreateOrder.swift

import Fluent

struct CreateOrderItem: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("order_items")
            .id()
            .field("order_id", .uuid, .required, .references("orders", "id", onDelete: .cascade))
            .field("product_id", .string, .required, .references("products", "id"))
            .field("name", .string, .required)
            .field("price", .int, .required)
            .field("quantity", .int, .required)
            .field("image", .string, .required)
            .field("created_at", .datetime)
            .create()
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("order_items").delete()
    }
}
