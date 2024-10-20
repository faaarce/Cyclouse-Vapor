import Vapor


// Configure your application
public func configure(_ app: Application) throws {
  // Register routes
  try routes(app)
  
  // Serve static files
  app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
}

// Register your routes

