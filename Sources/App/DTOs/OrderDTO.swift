//
//  File.swift
//  Cyclouse
//
//  Created by yoga arie on 22/03/25.
//


import Vapor

struct CheckoutRequest: Content {
    struct Item: Content {
        let productId: String
        let quantity: Int
    }
    
    struct ShippingAddress: Content {
        let street: String
        let city: String
        let state: String
        let zipCode: String
        let country: String
    }
    
    struct PaymentMethod: Content {
        let type: String
        let bank: String?
    }
    
    let items: [Item]
    let shippingAddress: ShippingAddress
    let paymentMethod: PaymentMethod
}

struct OrderItemResponse: Content {
    let productId: String
    let name: String
    let price: Int
    let quantity: Int
    let image: String
}

struct PaymentMethodResponse: Content {
    let type: String
    let bank: String?
}

struct PaymentDetailsResponse: Content {
    let amount: Int
    let bank: String?
    let virtualAccountNumber: String?
    let expiryDate: Date?
}

struct OrderResponse: Content {
    let orderId: UUID
    let userId: UUID
    let status: String
    let shippingAddress: String
    let items: [OrderItemResponse]
    let paymentMethod: PaymentMethodResponse
    let paymentDetails: PaymentDetailsResponse
    let total: Int
    let createdAt: Date
}

struct OrderListResponse: Content {
    let success: Bool
    let message: String
    let data: [OrderResponse]
}

struct OrderStatusUpdateRequest: Content {
    let status: String
}


struct CheckoutResponseItemDTO: Content {
    let productId: String
    let name: String
    let price: Int
    let quantity: Int
    let image: String
}

struct CheckoutResponsePaymentMethodDTO: Content {
    let type: String
    let bank: String?
}

struct CheckoutResponsePaymentDetailsDTO: Content {
    let amount: Int
    let virtualAccountNumber: String
    let expiryDate: String
    let bank: String?
}

struct CheckoutResponseDataDTO: Content {
    let orderId: String
    let userId: String
    let status: String
    let shippingAddress: String
    let items: [CheckoutResponseItemDTO]
    let paymentMethod: CheckoutResponsePaymentMethodDTO
    let paymentDetails: CheckoutResponsePaymentDetailsDTO
    let total: Int
    let createdAt: String
}

struct CheckoutResponseDTO: Content {
    let success: Bool
    let message: String
    let data: CheckoutResponseDataDTO
}

struct OrderDetailResponseDTO: Content {
    let success: Bool
    let message: String
    let data: OrderDetailDataDTO
}

struct OrderDetailDataDTO: Content {
    let orderId: String
    let userId: String
    let status: String
    let shippingAddress: String
    let items: [OrderItemDetailDTO]
    let paymentMethod: PaymentMethodDetailDTO
    let paymentDetails: PaymentDetailsDetailDTO
    let total: Int
    let createdAt: String
}

struct OrderItemDetailDTO: Content {
    let productId: String
    let name: String
    let price: Int
    let quantity: Int
    let image: String
}

struct PaymentMethodDetailDTO: Content {
    let type: String
    let bank: String?
}

struct PaymentDetailsDetailDTO: Content {
    let amount: Int
    let virtualAccountNumber: String?
    let expiryDate: String?
    let bank: String?
}


struct OrderStatusUpdateResponseDTO: Content {
    let success: Bool
    let message: String
    let data: OrderStatusUpdateDataDTO
}

struct OrderStatusUpdateDataDTO: Content {
    let orderId: String
    let status: String
    let updatedAt: String
}

struct OrderListResponseDTO: Content {
    let success: Bool
    let message: String
    let data: [OrderHistoryDTO] 
}

struct OrderListDataDTO: Content {
    let orders: [OrderSummaryDTO]
}

struct OrderSummaryDTO: Content {
    let orderId: String
    let status: String
    let total: Int
    let itemCount: Int
    let createdAt: String
}

struct OrderHistoryDTO: Content {
    let orderId: String
    let items: [OrderItemDetailDTO]  // Reuse your existing DTO
    let total: Int
    let createdAt: String
    let shippingAddress: String
    let status: String
    let userId: String
    let paymentMethod: PaymentMethodDetailDTO
    let paymentDetails: PaymentDetailsDetailDTO
}
