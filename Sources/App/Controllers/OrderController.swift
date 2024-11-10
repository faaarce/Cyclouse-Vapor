//
//  File.swift
//  Cyclouse
//
//  Created by yoga arie on 10/11/24.
//

import Vapor

struct OrderController {
    static func confirmOrder(_ req: Request) async throws -> Response {
        let authInfo = try req.auth.require(AuthInfo.self)

        // Extract orderId from the URL
        guard let orderIdString = req.parameters.get("orderId"),
              let orderId = UUID(uuidString: orderIdString) else {
            throw Abort(.badRequest, reason: "Invalid order ID")
        }

        // Decode the request body
        let confirmRequest = try req.content.decode(ConfirmOrderRequest.self)

        // Find the order
        guard var order = CheckoutController.mockOrderStorage[orderId] else {
            throw Abort(.notFound, reason: "Order not found")
        }

        // Verify the user owns the order
        guard order.userId == authInfo.userId else {
            throw Abort(.forbidden, reason: "Not authorized to modify this order")
        }

        // Update the order status
        order.status = confirmRequest.status
        let updatedAt = Date()

        // Save the updated order
        CheckoutController.mockOrderStorage[orderId] = order

        // Prepare the response
        let responseBody = APIResponse(
            success: true,
            message: "Order status updated to \(order.status)",
            data: ConfirmOrderResponse(
                orderId: order.id,
                status: order.status,
                updatedAt: updatedAt
            )
        )
        let response = Response(status: .ok)
        try response.content.encode(responseBody)
        return response
    }
}

// Define request and response structs
struct ConfirmOrderRequest: Content {
    let status: String
}

struct ConfirmOrderResponse: Content {
    let orderId: UUID
    let status: String
    let updatedAt: Date
}
