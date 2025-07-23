//
//  File.swift
//  Cyclouse
//
//  Created by yoga arie on 22/07/25.
//
import Vapor
import Fluent
import Foundation

// First, we need a proper model for our rollback data
final class MigrationRollback: Model, Content {
    static let schema = "migration_rollback_temp"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "product_id")
    var productId: String
    
    @Field(key: "old_description")
    var oldDescription: String
    
    @Field(key: "migration_name")
    var migrationName: String
    
    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?
    
    init() { }
    
    init(id: UUID? = nil, productId: String, oldDescription: String, migrationName: String) {
        self.id = id
        self.productId = productId
        self.oldDescription = oldDescription
        self.migrationName = migrationName
    }
}

