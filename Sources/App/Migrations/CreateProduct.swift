//
//  File.swift
//  Cyclouse
//
//  Created by yoga arie on 22/03/25.
//
// Sources/App/Migrations/CreateProduct.swift
import Fluent

struct CreateProduct: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("products")
            .field("id", .string, .identifier(auto: false))
            .field("category_id", .string, .required, .references("product_categories", "id", onDelete: .cascade))
            .field("name", .string, .required)
            .field("description", .string)
            .field("brand", .string, .required)
            .field("price", .int, .required)
            .field("quantity", .int, .required)
            .field("created_at", .datetime)
            .field("updated_at", .datetime)
            .create()
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("products").delete()
    }
}
