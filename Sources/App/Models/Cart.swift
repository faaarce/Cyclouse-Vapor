//
//  File.swift
//  Cyclouse
//
//  Created by yoga arie on 29/09/24.
//
import Vapor
import Foundation

struct CartItem: Content {
    let productId: String
    let quantity: Int
}

struct Cart: Content {
    var items: [CartItem]
}

struct AddToCartRequest: Content {
    let productId: String
    let quantity: Int
}
