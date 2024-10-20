//
//  File.swift
//  Cyclouse
//
//  Created by yoga arie on 20/10/24.
//

import Foundation
import Network
import Vapor

struct OrderHistoryController {
    static func getOrderHistory(_ req: Request) async throws -> Response {
        let authInfo = try req.auth.require(AuthInfo.self)
        let status = try? req.query.get(String.self, at: "status")

        // Fetch orders from database (simulated here)
        let orders = try await fetchOrders(userId: authInfo.userId, status: status)

        let responseBody = APIResponse<[Order]>(
            success: true,
            message: "Order history retrieved successfully",
            data: orders
        )

        return try await responseBody.encodeResponse(for: req)
    }

    // Simulated database fetch
    private static func fetchOrders(userId: UUID, status: String?) async throws -> [Order] {
      let userOrders = CheckoutController.orders.filter { $0.userId == userId }
           
           if let status = status {
               return userOrders.filter { $0.status == status }
           }
           return userOrders
    }
}
