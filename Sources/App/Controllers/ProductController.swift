//
//  File.swift
//  Cyclouse
//
//  Created by yoga arie on 22/03/25.
//
// Sources/App/Controllers/ProductController.swift
import Vapor
import Fluent

struct ProductController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let products = routes.grouped("product")
        products.get(use: getAllProducts)
        products.get(":productId", use: getProductById)
    }
    
    func getAllProducts(req: Request) async throws -> ProductCatalogResponse {
        let categories = try await ProductCategory.query(on: req.db).all()
        
        var categoryDTOs: [CategoryWithProductsDTO] = []
        
        for category in categories {
            let products = try await Product.query(on: req.db)
                .filter(\.$category.$id == category.id!)
                .all()
            
            var productDTOs: [ProductResponseDTO] = []
            
            for product in products {
                let images = try await product.$images.query(on: req.db).all()
                let productDTO = ProductResponseDTO(
                    product: product,
                    images: images,
                    categoryName: category.name
                )
                productDTOs.append(productDTO)
            }
            
            let categoryDTO = CategoryWithProductsDTO(
                categoryName: category.name,
                products: productDTOs
            )
            
            categoryDTOs.append(categoryDTO)
        }
        
        return ProductCatalogResponse(
            success: true,
            message: "Data fetched successfully",
            bikes: ProductCatalogResponse.BikesContainer(categories: categoryDTOs)
        )
    }
    
    func getProductById(req: Request) async throws -> ProductResponseDTO {
        guard let productId = req.parameters.get("productId") else {
            throw Abort(.badRequest, reason: "Product ID is required")
        }
        
        guard let product = try await Product.query(on: req.db)
            .filter(\.$id == productId)
            .first() else {
            throw Abort(.notFound, reason: "Product not found")
        }
        
        let images = try await product.$images.query(on: req.db).all()
        let category = try await product.$category.get(on: req.db)
        
        return ProductResponseDTO(
            product: product,
            images: images,
            categoryName: category.name
        )
    }
}
