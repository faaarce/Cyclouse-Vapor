//
//  File.swift
//  Cyclouse
//
//  Created by yoga arie on 29/09/24.
//

import Vapor


struct ProductResponse: Content {
  let message: String
  let success: Bool
  let bikes: Bikes
}

struct Bikes: Content {
  var categories: [Category]
}

struct Category: Content {
  let categoryName: String
  let products: [Product]
}

struct Product: Content {
  let id: String
  let name: String
  let description: String
  let images: [String]
  let price: Int
  let brand: String
  let quantity: Int
}
