//
//  File.swift
//  Cyclouse
//
//  Created by yoga arie on 19/06/25.
//

import Foundation
import Fluent

struct AddShippingFieldsToOrders: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema("orders")
            .field("shipping_type", .string, .required, .sql(.default("regular")))
            .field("shipping_cost", .int, .required, .sql(.default(25000)))
            .field("shipping_estimated_days", .string, .required, .sql(.default("3-5 hari kerja")))
            .update()
    }
    
    func revert(on database: Database) async throws {
        try await database.schema("orders")
            .deleteField("shipping_type")
            .deleteField("shipping_cost")
            .deleteField("shipping_estimated_days")
            .update()
    }
}
