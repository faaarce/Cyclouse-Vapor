import Vapor

func routes(_ app: Application) throws {
 
  // Root route now uses the same handler as the /product route
  app.get(use: ProductController.getProducts)
  app.get("product", ":id", use: ProductController.getProductById)
  // Product route (now identical to root route)
  app.get("product", use: ProductController.getProducts)
  
  // Auth routes
  let authGroup = app.grouped("auth")
  app.post("auth", "login", use: AuthController.login)
  authGroup.post("login", use: AuthController.login)
  authGroup.post("register", use: AuthController.register)
  app.get("user", ":userId", use: AuthController.getUser)
  // Cart routes (protected by auth middleware)
  let cartGroup = app.grouped(AuthMiddleware())
  cartGroup.get("user", ":userId", use: AuthController.getUser)
  cartGroup.post("cart", "add", use: CartController.addToCart)
  cartGroup.post("auth", "logout", use: AuthController.logout)
  cartGroup.get("cart", use: CartController.getCart)
  cartGroup.post("checkout", use: CheckoutController.checkout)
  cartGroup.get("orders", use: OrderHistoryController.getOrderHistory)
  cartGroup.post("orders", ":orderId", "confirm", use: OrderController.confirmOrder)
  cartGroup.get("orders", ":orderId", use: OrderController.getOrderDetails)
}
