import Vapor
import Fluent
import FluentPostgresDriver
import JWT

// Configure your application
public func configure(_ app: Application) throws {
  // Register routes
  app.jwt.signers.use(.hs256(key: Environment.get("JWT_SECRET") ?? "cyclouse-temporary-secret"))
    
  app.databases.use(.postgres(hostname: "localhost", port: 5434, username: "cyclouse_user", password: "mypassword", database: "cyclousedb"), as: .psql)

  app.migrations.add(CreateUser())
  app.migrations.add(CreateAuthToken())
  app.migrations.add(CreateProductCategory())
  app.migrations.add(CreateProduct())
  app.migrations.add(CreateProductImage())
  app.migrations.add(CreateCart())
  app.migrations.add(CreateCartItem())
  app.migrations.add(CreateOrder())
  app.migrations.add(CreateOrderItem())

  // Add the database seeder
  app.migrations.add(DatabaseSeeder())

//  try app.autoMigrate().wait()

  
  try routes(app)
  
  // Serve static files
  app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
}

// Register your routes

