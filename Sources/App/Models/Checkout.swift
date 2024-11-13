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
  let paymentMethod: PaymentMethod
}

struct PaymentMethod: Content {
    let type: String // e.g., "bankTransfer"
    let bank: String // e.g., "Bank Mandiri", "BRI", "BCA", "BNI"
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
    let items: [OrderItem]
    let total: Int
    let shippingAddress: String
    var status: String
    let createdAt: Date
    let paymentMethod: PaymentMethod
    let paymentDetails: PaymentDetails

    enum CodingKeys: String, CodingKey {
        case id = "orderId"
        case userId
        case items
        case total
        case shippingAddress
        case status
        case createdAt
        case paymentMethod
        case paymentDetails
    }
}


struct OrderItem: Content {
    let productId: String
    let name: String
    let quantity: Int
    let price: Int
  let image: String
}


struct PaymentDetails: Content {
    let virtualAccountNumber: String // Dummy account number
    let bank: String
    let amount: Int
    let expiryDate: Date
}
