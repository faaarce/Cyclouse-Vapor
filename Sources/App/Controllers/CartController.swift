//
//  File.swift
//  Cyclouse
//
//  Created by yoga arie on 29/09/24.
//

import Vapor

class CartController {
    static var carts: [UUID: Cart] = [:]
    
    static func addToCart(_ req: Request) async throws -> Response {
        let authInfo = try req.auth.require(AuthInfo.self)
        let addRequest = try req.content.decode(AddToCartRequest.self)
        
        let cartItem = CartItem(productId: addRequest.productId, quantity: addRequest.quantity)
        
        if carts[authInfo.userId] == nil {
            carts[authInfo.userId] = Cart(items: [])
        }
        carts[authInfo.userId]?.items.append(cartItem)
        
        let response = Response(status: .ok)
        let responseBody = APIResponse(
            success: true,
            message: "Item added successfully!",
            data: AddToCartResponse(items: carts[authInfo.userId]?.items ?? [])
        )
        try response.content.encode(responseBody)
        
        return response
    }
    
    static func getCart(_ req: Request) async throws -> APIResponse<Cart> {
        let authInfo = try req.auth.require(AuthInfo.self)
        
        let cart = carts[authInfo.userId] ?? Cart(items: [])
        return APIResponse(success: true, message: "Cart retrieved successfully", data: cart)
    }
}

struct AddToCartResponse: Content {
    let items: [CartItem]
}
