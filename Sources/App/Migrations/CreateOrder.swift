//
//  File.swift
//  Cyclouse
//
//  Created by yoga arie on 22/03/25.
//
// Sources/App/Migrations/CreateOrder.swift
import Fluent

struct CreateOrder: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("orders")
            .id()
            .field("user_id", .uuid, .required, .references("users", "id", onDelete: .cascade))
            .field("status", .string, .required)
            .field("shipping_address", .string, .required)
            .field("payment_method_type", .string, .required)
            .field("payment_method_bank", .string)
            .field("payment_details_amount", .int, .required)
            .field("payment_details_virtual_account", .string)
            .field("payment_details_expiry_date", .datetime)
            .field("total", .int, .required)
            .field("created_at", .datetime)
            .field("updated_at", .datetime)
            .create()
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("orders").delete()
    }
}
