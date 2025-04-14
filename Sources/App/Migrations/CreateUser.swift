//
//  File.swift
//  Cyclouse
//
//  Created by yoga arie on 22/03/25.
//
// Sources/App/Migrations/CreateUser.swift
import Fluent

struct CreateUser: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("users")
            .id()
            .field("name", .string, .required)
            .field("email", .string, .required)
            .field("phone", .string, .required)
            .field("password", .string, .required)
            .field("created_at", .datetime)
            .field("updated_at", .datetime)
            .unique(on: "email")
            .create()
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("users").delete()
    }
}
