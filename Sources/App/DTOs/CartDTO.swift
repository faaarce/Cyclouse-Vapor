//
//  File.swift
//  Cyclouse
//
//  Created by yoga arie on 22/03/25.
//
// Sources/App/DTOs/CartDTO.swift
import Vapor

struct CartItemRequest: Content {
    let productId: String
    let quantity: Int
}

struct CartItemResponse: Content {
    let productId: String
    let quantity: Int
}

struct CartResponse: Content {
    let success: Bool
    let message: String
    let data: CartData
    
    struct CartData: Content {
        let items: [CartItemResponse]
    }
}
