import Vapor

func routes(_ app: Application) throws {
    // Basic health check
    app.get { req in
        return "CycleUse API is running!"
    }
  app.get("db-check") { req async throws -> String in
      let categories = try await ProductCategory.query(on: req.db).all()
      var result = "Database Status:\n"
      
      for category in categories {
          // Fixed: Use the correct filter syntax
          let products = try await Product.query(on: req.db)
              .filter(\Product.$category.$id, .equal, category.id!)
              .all()
          
          result += "\(category.name): \(products.count) products\n"
          
          // Sample first product images if any exist
          if let firstProduct = products.first {
              // Also fix this filter
              let images = try await ProductImage.query(on: req.db)
                  .filter(\ProductImage.$product.$id, .equal, firstProduct.id!)
                  .count()
              result += "  - First product has \(images) images\n"
          }
      }
      
      return result
  }
  // Register controllers
  try app.register(collection: AuthController())
  try app.register(collection: ProductController())
  try app.register(collection: ShippingController()) 
  
  // Protected routes
  let protected = app.grouped(JWTAuthenticator())
  
  try protected.register(collection: CartController())
  try protected.register(collection: OrderController())
  try protected.register(collection: UserController())
  
}
