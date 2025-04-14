//
//  File.swift
//  Cyclouse
//
//  Created by yoga arie on 22/03/25.
//
// Sources/App/DTOs/ProductDTO.swift
import Vapor

struct ProductResponseDTO: Content {
    let id: String
    let name: String
    let description: String
    let brand: String
    let price: Int
    let quantity: Int
    let images: [String]
    let categoryName: String
    
    init(product: Product, images: [ProductImage], categoryName: String) {
        self.id = product.id!
        self.name = product.name
        self.description = product.description
        self.brand = product.brand
        self.price = product.price
        self.quantity = product.quantity
        self.images = images.sorted(by: { $0.displayOrder < $1.displayOrder }).map { $0.imageUrl }
        self.categoryName = categoryName
    }
}

struct CategoryWithProductsDTO: Content {
    let categoryName: String
    let products: [ProductResponseDTO]
}

struct ProductCatalogResponse: Content {
    let success: Bool
    let message: String
    let bikes: BikesContainer
    
    struct BikesContainer: Content {
        let categories: [CategoryWithProductsDTO]
    }
}
