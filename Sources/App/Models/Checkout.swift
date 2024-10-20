//
//  File.swift
//  Cyclouse
//
//  Created by yoga arie on 19/10/24.
//

import Vapor

struct CheckoutRequest: Content {
    let items: [CartItem]
    let shippingAddress: ShippingAddress
}

struct ShippingAddress: Content {
    let street: String
    let city: String
    let state: String
    let zipCode: String
    let country: String
}

struct Order: Content {
  let id: UUID
  let userId: UUID
  let items: [CartItem]
  let total: Int
  let shippingAddress: String
  let status: String
  let createdAt: Date
}

struct OrderItem: Content {
    let productId: String
    let name: String
    let quantity: Int
    let price: Int
}
