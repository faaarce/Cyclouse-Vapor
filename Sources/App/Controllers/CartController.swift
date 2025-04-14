//
//  File.swift
//  Cyclouse
//
//  Created by yoga arie on 22/03/25.
//

import Vapor
import Fluent

struct CartController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let cartRoutes = routes.grouped("cart")
            .grouped(JWTAuthenticator())
        
        cartRoutes.get(use: getCart)
        cartRoutes.post("add", use: addToCart)
    }
    
    func getCart(req: Request) async throws -> CartResponse {
        let payload = try req.auth.require(AuthPayload.self)
        guard let userId = UUID(payload.sub.value) else {
            throw Abort(.badRequest, reason: "Invalid user ID in token")
        }
        
        // Find user's cart
        guard let cart = try await Cart.query(on: req.db)
            .filter(\.$user.$id == userId)
            .first() else {
            throw Abort(.notFound, reason: "Cart not found")
        }
        
        // Get cart items
        let cartItems = try await cart.$items.query(on: req.db).all()
        
        let cartItemResponses = cartItems.map { item in
            CartItemResponse(
                productId: item.$product.id,
                quantity: item.quantity
            )
        }
        
        return CartResponse(
            success: true,
            message: "Cart retrieved successfully",
            data: CartResponse.CartData(items: cartItemResponses)
        )
    }
    
    func addToCart(req: Request) async throws -> CartResponse {
        let payload = try req.auth.require(AuthPayload.self)
        guard let userId = UUID(payload.sub.value) else {
            throw Abort(.badRequest, reason: "Invalid user ID in token")
        }
        
        let cartItemRequest = try req.content.decode(CartItemRequest.self)
        
        // Validate product exists
        guard let product = try await Product.find(cartItemRequest.productId, on: req.db) else {
            throw Abort(.notFound, reason: "Product not found")
        }
        
        // Validate quantity
        guard cartItemRequest.quantity > 0 else {
            throw Abort(.badRequest, reason: "Quantity must be greater than 0")
        }
        
        guard cartItemRequest.quantity <= product.quantity else {
            throw Abort(.badRequest, reason: "Not enough stock available")
        }
        
        // Find or create cart
        let cart = try await Cart.query(on: req.db)
            .filter(\.$user.$id == userId)
            .first() ?? Cart(userId: userId)
        
        if cart.id == nil {
            try await cart.save(on: req.db)
        }
        
        // Check if item already exists in cart
        if let existingItem = try await CartItem.query(on: req.db)
            .filter(\.$cart.$id == cart.id!)
            .filter(\.$product.$id == cartItemRequest.productId)
            .first() {
            
            // Update quantity
            existingItem.quantity = cartItemRequest.quantity
            try await existingItem.save(on: req.db)
        } else {
            // Create new cart item
            let cartItem = CartItem(
                cartId: cart.id!,
                productId: cartItemRequest.productId,
                quantity: cartItemRequest.quantity
            )
            try await cartItem.save(on: req.db)
        }
        
        // Get updated cart items
        let cartItems = try await cart.$items.query(on: req.db).all()
        
        let cartItemResponses = cartItems.map { item in
            CartItemResponse(
                productId: item.$product.id,
                quantity: item.quantity
            )
        }
        
        return CartResponse(
            success: true,
            message: "Item added successfully!",
            data: CartResponse.CartData(items: cartItemResponses)
        )
    }
}
