//
//  File.swift
//  Cyclouse
//
//  Created by yoga arie on 22/03/25.
//

// Sources/App/Migrations/CreateProductCategory.swift
import Fluent

struct CreateProductCategory: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("product_categories")
            .field("id", .string, .identifier(auto: false))
            .field("name", .string, .required)
            .field("created_at", .datetime)
            .create()
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("product_categories").delete()
    }
}
