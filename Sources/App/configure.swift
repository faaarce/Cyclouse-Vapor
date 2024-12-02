import Vapor
import Fluent
import FluentPostgresDriver

// Configure your application
public func configure(_ app: Application) throws {
  // Register routes
  app.databases.use(.postgres(
      hostname: Environment.get("DATABASE_HOST") ?? "localhost",
      port: Environment.get("DATABASE_PORT").flatMap(Int.init(_:)) ?? 5432,
      username: "postgres",  // Hardcode the correct username here
      password: "cyclouse123",  // Hardcode the correct password here
      database: "cyclouse_db"  // Use the correct database name
  ), as: .psql)


  // Configure migrations
  app.migrations.add(CreateUser())  // We'll create this migration next
//  app.migrations.add(CreateOrderMigration())
  // Run migrations
  try app.autoMigrate().wait()

  
  try routes(app)
  
  // Serve static files
  app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
}

// Register your routes

