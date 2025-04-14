//
//  File.swift
//  Cyclouse
//
//  Created by yoga arie on 22/03/25.
//

// Sources/App/Migrations/CreateAuthToken.swift
import Fluent

struct CreateAuthToken: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("auth_tokens")
            .id()
            .field("user_id", .uuid, .required, .references("users", "id", onDelete: .cascade))
            .field("token", .string, .required)
            .field("is_blacklisted", .bool, .required, .sql(.default(false)))
            .field("expires_at", .datetime, .required)
            .field("created_at", .datetime)
            .create()
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("auth_tokens").delete()
    }
}
