//
//  File.swift
//  Cyclouse
//
//  Created by yoga arie on 19/10/24.
//
import Vapor


struct CheckoutController {
  static var orders: [Order] = []

     static var mockOrderStorage: [UUID: Order] = [:]

  static func checkout(_ req: Request) async throws -> Response {
      let authInfo = try req.auth.require(AuthInfo.self)
      let checkoutRequest = try req.content.decode(CheckoutRequest.self)
      
      guard !checkoutRequest.items.isEmpty else {
          throw Abort(.badRequest, reason: "Cart is empty")
      }
      
      let (total, validatedItems) = try validateAndCalculateTotal(req, checkoutRequest.items)
      let order = createOrder(
          userId: authInfo.userId,
          items: validatedItems,
          total: total,
          shippingAddress: checkoutRequest.shippingAddress,
          paymentMethod: checkoutRequest.paymentMethod
      )
      
      // Save the order (in a real app, this would be to a database)
      mockOrderStorage[order.id] = order
      orders.append(order)
      
      // Prepare response
      let response = Response(status: .ok)
      let encoder = JSONEncoder()
      encoder.dateEncodingStrategy = .iso8601
      response.headers.add(name: .contentType, value: "application/json")
      let responseBody = APIResponse(success: true, message: "Checkout successful", data: order)
      response.body = try .init(data: encoder.encode(responseBody))
      
      return response
  }

  
  private static func generateVirtualAccountNumber(for bank: String) -> String {
      let bankCode: String
      switch bank {
      case "Bank Mandiri":
          bankCode = "700"
      case "BRI":
          bankCode = "002"
      case "BCA":
          bankCode = "014"
      case "BNI":
          bankCode = "009"
      default:
          bankCode = "000"
      }
      let randomDigits = String(format: "%09d", Int.random(in: 0...999999999))
      return bankCode + randomDigits
  }

}


// Update the createOrder function in CheckoutController to include images
extension CheckoutController {
    private static func createOrder(
        userId: UUID,
        items: [OrderItem],
        total: Int,
        shippingAddress: ShippingAddress,
        paymentMethod: PaymentMethod
    ) -> Order {
        let virtualAccountNumber = generateVirtualAccountNumber(for: paymentMethod.bank)
        let expiryDate = Calendar.current.date(byAdding: .day, value: 1, to: Date())!
        let paymentDetails = PaymentDetails(
            virtualAccountNumber: virtualAccountNumber,
            bank: paymentMethod.bank,
            amount: total,
            expiryDate: expiryDate
        )
        
        return Order(
            id: UUID(),
            userId: userId,
            items: items,
            total: total,
            shippingAddress: "\(shippingAddress.street), \(shippingAddress.city), \(shippingAddress.state) \(shippingAddress.zipCode), \(shippingAddress.country)",
            status: "pending",
            createdAt: Date(),
            paymentMethod: paymentMethod,
            paymentDetails: paymentDetails
        )
    }

    // Update the validateAndCalculateTotal function to include images
    private static func validateAndCalculateTotal(_ req: Request, _ items: [CartItem]) throws -> (Int, [OrderItem]) {
        var total = 0
        var validatedItems: [OrderItem] = []
        
        let productResponse = try ProductController.getProducts(req)
        let allProducts = productResponse.bikes.categories.flatMap { $0.products }
        
        for item in items {
            guard let product = allProducts.first(where: { $0.id == item.productId }) else {
                throw Abort(.badRequest, reason: "Invalid product ID: \(item.productId)")
            }
            
            guard product.quantity >= item.quantity else {
                throw Abort(.badRequest, reason: "Insufficient quantity for product: \(product.name)")
            }
            
            let itemTotal = product.price * item.quantity
            total += itemTotal
            
            // Create OrderItem with the first image from the product
            let orderItem = OrderItem(
                productId: item.productId,
                name: product.name,
                quantity: item.quantity,
                price: product.price,
                image: product.images.first ?? "" // Use first image or empty string if no images
            )
            validatedItems.append(orderItem)
        }
        
        return (total, validatedItems)
    }
}

