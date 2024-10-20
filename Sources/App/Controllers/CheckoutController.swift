//
//  File.swift
//  Cyclouse
//
//  Created by yoga arie on 19/10/24.
//
import Vapor


struct CheckoutController {
  static var orders: [Order] = []

    private static var mockOrderStorage: [UUID: Order] = [:]

    static func checkout(_ req: Request) async throws -> Response {
        let authInfo = try req.auth.require(AuthInfo.self)
        let checkoutRequest = try req.content.decode(CheckoutRequest.self)
        
        guard !checkoutRequest.items.isEmpty else {
            throw Abort(.badRequest, reason: "Cart is empty")
        }
        
        let (total, validatedItems) = try validateAndCalculateTotal(req, checkoutRequest.items)
        let order = createOrder(userId: authInfo.userId, items: validatedItems, total: total, shippingAddress: checkoutRequest.shippingAddress)
        
        // Save the order (in a real app, this would be to a database)
        mockOrderStorage[order.id] = order
        
      orders.append(order)
      let response = Response(status: .ok)
        let responseBody = APIResponse(success: true, message: "Checkout successful", data: order)
        try response.content.encode(responseBody)
        
        return response
    }
    
    private static func validateAndCalculateTotal(_ req: Request, _ items: [CartItem]) throws -> (Int, [CartItem]) {
        var total = 0
        var validatedItems: [CartItem] = []
        
        let productResponse = try ProductController.getProducts(req)
        let allProducts = productResponse.bikes.categories.flatMap { $0.products }
        
        for item in items {
            guard let product = allProducts.first(where: { $0.id == item.productId }) else {
                throw Abort(.badRequest, reason: "Invalid product ID: \(item.productId)")
            }
            
            guard product.quantity >= item.quantity else {
                throw Abort(.badRequest, reason: "Insufficient quantity for product: \(product.name)")
            }
            
            total += product.price * item.quantity
            validatedItems.append(item)
        }
        
        return (total, validatedItems)
    }
    
    private static func createOrder(userId: UUID, items: [CartItem], total: Int, shippingAddress: ShippingAddress) -> Order {
        return Order(
            id: UUID(),
            userId: userId,
            items: items,
            total: total,
            shippingAddress: "\(shippingAddress.street), \(shippingAddress.city), \(shippingAddress.state) \(shippingAddress.zipCode), \(shippingAddress.country)",
            status: "pending",
            createdAt: Date()
        )
    }
}
