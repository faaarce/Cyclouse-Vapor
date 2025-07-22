//
//  File.swift
//  Cyclouse
//
//  Created by yoga arie on 22/03/25.
//
// Sources/App/Controllers/OrderController.swift
import Vapor
import Fluent

struct OrderController: RouteCollection {
  func boot(routes: RoutesBuilder) throws {
    let orders = routes.grouped("orders")
    orders.get(use: getOrders)
    orders.get(":orderId", use: getOrderById)
    orders.post(":orderId", "confirm", use: updateOrderStatus)
    
    // Checkout endpoint
    routes.post("checkout", use: checkout)
  }
  // Get all orders for the authenticated user
  /*func getOrders(req: Request) async throws -> OrderListResponseDTO {
      let payload = try req.auth.require(AuthPayload.self)
      guard let userId = UUID(payload.sub.value) else {
          throw Abort(.badRequest, reason: "Invalid user ID in token")
      }
      
      // Fetch all orders for this user
      let orders = try await Order.query(on: req.db)
          .filter(\.$user.$id == userId)
          .sort(\.$createdAt, .descending)
          .all()
      
      // Use a for loop instead of map for async operations
      var orderResponses: [OrderSummaryDTO] = []
      for order in orders {
          let itemCount = try await order.$items.query(on: req.db).count()
          
          let summary = OrderSummaryDTO(
              orderId: order.id!.uuidString,
              status: order.status,
              total: order.total,
              itemCount: itemCount,
              createdAt: ISO8601DateFormatter().string(from: order.createdAt ?? Date())
          )
          orderResponses.append(summary)
      }
      
      return OrderListResponseDTO(
          success: true,
          message: "Orders retrieved successfully",
          data: OrderListDataDTO(
              orders: orderResponses
          )
      )
  }*/
  func getOrders(req: Request) async throws -> OrderListResponseDTO {
      let payload = try req.auth.require(AuthPayload.self)
      guard let userId = UUID(payload.sub.value) else {
          throw Abort(.badRequest, reason: "Invalid user ID in token")
      }
      
      // Fetch all orders for this user
      let orders = try await Order.query(on: req.db)
          .filter(\.$user.$id == userId)
          .sort(\.$createdAt, .descending)
          .all()
      
      // Create full OrderHistory objects instead of just summaries
      var orderHistories: [OrderHistoryDTO] = []
      for order in orders {
          // Fetch items for each order
          let items = try await order.$items.query(on: req.db).all()
          
          // Map items to the expected DTO format
          let itemDTOs = items.map { item in
              OrderItemDetailDTO(
                  productId: item.$product.id,
                  name: item.name,
                  price: item.price,
                  quantity: item.quantity,
                  image: item.image
              )
          }
          
          // Date formatting for nullable date
          let expiryDateString: String?
          if let expiryDate = order.paymentDetailsExpiryDate {
              expiryDateString = ISO8601DateFormatter().string(from: expiryDate)
          } else {
              expiryDateString = nil
          }
        
        // Calculate estimated delivery date for historical orders
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd MMMM yyyy"
                dateFormatter.locale = Locale(identifier: "id_ID")
                
                var estimatedDeliveryDate = ""
                if let createdAt = order.createdAt {
                    switch order.shippingType {
                    case "same_day":
                        estimatedDeliveryDate = dateFormatter.string(from: createdAt)
                    case "express":
                        let deliveryDate = Calendar.current.date(byAdding: .day, value: 2, to: createdAt)!
                        estimatedDeliveryDate = dateFormatter.string(from: deliveryDate)
                    default:
                        let deliveryDate = Calendar.current.date(byAdding: .day, value: 5, to: createdAt)!
                        estimatedDeliveryDate = dateFormatter.string(from: deliveryDate)
                    }
                }
                
                // Map shipping type to display name
                let shippingTypeName = switch order.shippingType {
                    case "same_day": "Same Day"
                    case "express": "Express"
                    default: "Regular"
                }
                
          
          // Create the complete order history object
          let orderHistory = OrderHistoryDTO(
              orderId: order.id!.uuidString,
              items: itemDTOs,
              total: order.total,
              createdAt: ISO8601DateFormatter().string(from: order.createdAt ?? Date()),
              shippingAddress: order.shippingAddress,
              status: order.status,
              userId: userId.uuidString,
              paymentMethod: PaymentMethodDetailDTO(
                  type: order.paymentMethodType,
                  bank: order.paymentMethodBank
              ),
              paymentDetails: PaymentDetailsDetailDTO(
                  amount: order.paymentDetailsAmount,
                  virtualAccountNumber: order.paymentDetailsVirtualAccount,
                  expiryDate: expiryDateString,
                  bank: order.paymentMethodBank
              ),  shipping: ShippingInfoDTO(
                type: order.shippingType,
                typeName: shippingTypeName,
                cost: order.shippingCost,
                estimatedDays: order.shippingEstimatedDays,
                estimatedDeliveryDate: estimatedDeliveryDate
            )
          )
          
          orderHistories.append(orderHistory)
      }
      
      // Return the response with the direct array in 'data'
      return OrderListResponseDTO(
          success: true,
          message: "Orders retrieved successfully",
          data: orderHistories
      )
  }
  
  // Create a new order with checkout
  func checkout(req: Request) async throws -> CheckoutResponseDTO {
    let payload = try req.auth.require(AuthPayload.self)
    guard let userId = UUID(payload.sub.value) else {
      throw Abort(.badRequest, reason: "Invalid user ID in token")
    }
    
    let checkoutRequest = try req.content.decode(CheckoutRequest.self)
    
    // Validate items
    guard !checkoutRequest.items.isEmpty else {
      throw Abort(.badRequest, reason: "No items in checkout")
    }
    
    // Define shipping options (same as in ShippingController)
      let shippingOptions: [String: (name: String, cost: Int, days: String)] = [
          "regular": ("Regular", 25000, "3-5 hari kerja"),
          "express": ("Express", 45000, "1-2 hari kerja"),
          "same_day": ("Same Day", 75000, "Hari ini")
      ]
      
      // Validate shipping method
      guard let selectedShipping = shippingOptions[checkoutRequest.shippingMethod.type] else {
          throw Abort(.badRequest, reason: "Invalid shipping method")
      }
    
    // Format shipping address
    let formattedAddress = "\(checkoutRequest.shippingAddress.street), \(checkoutRequest.shippingAddress.city), \(checkoutRequest.shippingAddress.state) \(checkoutRequest.shippingAddress.zipCode), \(checkoutRequest.shippingAddress.country)"
    
    // Create order
    let orderId = UUID()
    var productSubtotal = 0
    
    // Verify products and calculate total
    var orderItemDetails: [(Product, Int)] = []
    
    for item in checkoutRequest.items {
      guard let product = try await Product.find(item.productId, on: req.db) else {
        throw Abort(.notFound, reason: "Product not found: \(item.productId)")
      }
      
      guard product.quantity >= item.quantity else {
        throw Abort(.badRequest, reason: "Not enough stock for product: \(product.name)")
      }
      
      let itemTotal = product.price * item.quantity
      productSubtotal += itemTotal
      
      orderItemDetails.append((product, item.quantity))
    }
    
    // Calculate total with shipping
       let shippingCost = selectedShipping.cost
       let totalAmount = productSubtotal + shippingCost
    
    // Generate virtual account number (simulated)
    let virtualAccountNumber = String(format: "%012d", Int.random(in: 100000000...999999999))
    
    // Create the order
    let order = Order(
      id: orderId,
      userId: userId,
      status: "pending",
      shippingAddress: formattedAddress,
      shippingType: checkoutRequest.shippingMethod.type,
            shippingCost: shippingCost,
            shippingEstimatedDays: selectedShipping.days,
      paymentMethodType: checkoutRequest.paymentMethod.type,
      paymentMethodBank: checkoutRequest.paymentMethod.bank,
      paymentDetailsAmount: totalAmount,
      paymentDetailsVirtualAccount: virtualAccountNumber,
      paymentDetailsExpiryDate: Date().addingTimeInterval(24 * 60 * 60), // 24 hours from now
      total: totalAmount
    )
    
    try await order.save(on: req.db)
    
    // Create order items
    for (product, quantity) in orderItemDetails {
      // Get first image for the product
      let firstImage = try await product.$images.query(on: req.db).first()?.imageUrl ?? "https://placeholder.com/image.jpg"
      
      let orderItem = OrderItem(
        orderId: orderId,
        productId: product.id!,
        name: product.name,
        price: product.price,
        quantity: quantity,
        image: firstImage
      )
      
      try await orderItem.save(on: req.db)
      
      // Update product stock (optional, depending on your business logic)
       product.quantity -= quantity
       try await product.save(on: req.db)
    }
    
    // Fetch the complete order with items for response
    let orderItems = try await OrderItem.query(on: req.db)
      .filter(\.$order.$id == orderId)
      .all()
    
    let itemResponses = orderItems.map { item in
      CheckoutResponseItemDTO(
        productId: item.$product.id,
        name: item.name,
        price: item.price,
        quantity: item.quantity,
        image: item.image
      )
    }
    
    // Calculate estimated delivery date
      let estimatedDeliveryDate: String
      let dateFormatter = DateFormatter()
      dateFormatter.dateFormat = "dd MMMM yyyy"
      dateFormatter.locale = Locale(identifier: "id_ID")
      
      switch checkoutRequest.shippingMethod.type {
      case "same_day":
          estimatedDeliveryDate = "Hari ini"
      case "express":
          let deliveryDate = Calendar.current.date(byAdding: .day, value: 2, to: Date())!
          estimatedDeliveryDate = dateFormatter.string(from: deliveryDate)
      default: // regular
          let deliveryDate = Calendar.current.date(byAdding: .day, value: 5, to: Date())!
          estimatedDeliveryDate = dateFormatter.string(from: deliveryDate)
      }
      
    
    // Use the proper response struct instead of dictionary
    return CheckoutResponseDTO(
      success: true,
      message: "Checkout successful",
      data: CheckoutResponseDataDTO(
        orderId: orderId.uuidString,
        userId: userId.uuidString,
        status: "pending",
        shippingAddress: formattedAddress,
        items: itemResponses,
        paymentMethod: CheckoutResponsePaymentMethodDTO(
          type: checkoutRequest.paymentMethod.type,
          bank: checkoutRequest.paymentMethod.bank
        ),
        paymentDetails: CheckoutResponsePaymentDetailsDTO(
          amount: totalAmount,
          virtualAccountNumber: virtualAccountNumber,
          expiryDate: ISO8601DateFormatter().string(from: order.paymentDetailsExpiryDate!),
          bank: checkoutRequest.paymentMethod.bank
        ),  shipping: ShippingInfoDTO(
          type: checkoutRequest.shippingMethod.type,
          typeName: selectedShipping.name,
          cost: shippingCost,
          estimatedDays: selectedShipping.days,
          estimatedDeliveryDate: estimatedDeliveryDate
      ),
        total: totalAmount, productSubtotal: productSubtotal,
        createdAt: ISO8601DateFormatter().string(from: order.createdAt ?? Date())
      )
    )
  }
  
  // Get order by ID
  func getOrderById(req: Request) async throws -> OrderDetailResponseDTO {
    let payload = try req.auth.require(AuthPayload.self)
    guard let userId = UUID(payload.sub.value) else {
      throw Abort(.badRequest, reason: "Invalid user ID in token")
    }
    
    guard let orderIdString = req.parameters.get("orderId"),
          let orderId = UUID(orderIdString) else {
      throw Abort(.badRequest, reason: "Invalid order ID")
    }
    
    guard let order = try await Order.query(on: req.db)
      .filter(\.$id == orderId)
      .filter(\.$user.$id == userId)
      .first() else {
      throw Abort(.notFound, reason: "Order not found")
    }
    
    let items = try await order.$items.query(on: req.db).all()
    
    let itemResponses = items.map { item in
      OrderItemDetailDTO(
        productId: item.$product.id,
        name: item.name,
        price: item.price,
        quantity: item.quantity,
        image: item.image
      )
    }
    
    // Date formatting for nullable date
    let expiryDateString: String?
    if let expiryDate = order.paymentDetailsExpiryDate {
      expiryDateString = ISO8601DateFormatter().string(from: expiryDate)
    } else {
      expiryDateString = nil
    }
    
    return OrderDetailResponseDTO(
      success: true,
      message: "Order retrieved successfully",
      data: OrderDetailDataDTO(
        orderId: order.id!.uuidString,
        userId: userId.uuidString,
        status: order.status,
        shippingAddress: order.shippingAddress,
        items: itemResponses,
        paymentMethod: PaymentMethodDetailDTO(
          type: order.paymentMethodType,
          bank: order.paymentMethodBank
        ),
        paymentDetails: PaymentDetailsDetailDTO(
          amount: order.paymentDetailsAmount,
          virtualAccountNumber: order.paymentDetailsVirtualAccount,
          expiryDate: expiryDateString,
          bank: order.paymentMethodBank
        ),
        total: order.total,
        createdAt: ISO8601DateFormatter().string(from: order.createdAt ?? Date())
      )
    )
  }
  
  // Update order status
  func updateOrderStatus(req: Request) async throws -> OrderStatusUpdateResponseDTO {
    let payload = try req.auth.require(AuthPayload.self)
    guard let userId = UUID(payload.sub.value) else {
      throw Abort(.badRequest, reason: "Invalid user ID in token")
    }
    
    guard let orderIdString = req.parameters.get("orderId"),
          let orderId = UUID(orderIdString) else {
      throw Abort(.badRequest, reason: "Invalid order ID")
    }
    
    let statusUpdate = try req.content.decode(OrderStatusUpdateRequest.self)
    
    guard let order = try await Order.query(on: req.db)
      .filter(\.$id == orderId)
      .filter(\.$user.$id == userId)
      .first() else {
      throw Abort(.notFound, reason: "Order not found")
    }
    
    // Check valid status transitions
    let validStatuses = ["pending", "paid", "shipped", "delivered", "cancelled"]
    guard validStatuses.contains(statusUpdate.status) else {
      throw Abort(.badRequest, reason: "Invalid status value")
    }
    
    // Update the order status
    order.status = statusUpdate.status
    order.updatedAt = Date()
    try await order.save(on: req.db)
    
    return OrderStatusUpdateResponseDTO(
      success: true,
      message: "Order status updated to \(statusUpdate.status)",
      data: OrderStatusUpdateDataDTO(
        orderId: order.id!.uuidString,
        status: order.status,
        updatedAt: ISO8601DateFormatter().string(from: order.updatedAt!)
      )
    )
  }
}
