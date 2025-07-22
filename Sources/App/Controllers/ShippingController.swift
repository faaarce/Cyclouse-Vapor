//
//  File.swift
//  Cyclouse
//
//  Created by yoga arie on 19/06/25.
//

import Foundation
import Vapor
import Fluent


struct ShippingController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let shipping = routes.grouped("shipping")
        
        // Get available shipping options
        shipping.get("options", use: getShippingOptions)
    }
    
    // Get shipping options - this provides data for your UI
    func getShippingOptions(req: Request) async throws -> ShippingOptionsResponseDTO {
        // Define shipping options that match your UI design exactly
        let shippingOptions = [
            ShippingOptionDTO(
                type: "regular",
                name: "Regular",
                estimatedDays: "3-5 hari kerja",
                cost: 25000,
                description: "Estimasi 3-5 hari kerja",
                isPopular: false
            ),
            ShippingOptionDTO(
                type: "express",
                name: "Express",
                estimatedDays: "1-2 hari kerja",
                cost: 45000,
                description: "Estimasi 1-2 hari kerja",
                isPopular: false
            ),
            ShippingOptionDTO(
                type: "same_day",
                name: "Same Day",
                estimatedDays: "Hari ini",
                cost: 75000,
                description: "Diterima hari ini (order sebelum 14:00)",
                isPopular: true  // This will show the "TERPOPULER" badge
            )
        ]
        
        return ShippingOptionsResponseDTO(
            success: true,
            message: "Shipping options retrieved successfully",
            data: shippingOptions
        )
    }
}
