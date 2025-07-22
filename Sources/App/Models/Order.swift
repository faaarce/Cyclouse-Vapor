//
//  File.swift
//  Cyclouse
//
//  Created by yoga arie on 22/03/25.
//

// Sources/App/Models/Order.swift
import Fluent
import Vapor

final class Order: Model, Content {
    static let schema = "orders"
    
    @ID(key: .id)
    var id: UUID?
    
    @Parent(key: "user_id")
    var user: User
    
    @Field(key: "status")
    var status: String
    
    @Field(key: "shipping_address")
    var shippingAddress: String
  
  @Field(key: "shipping_type")
  var shippingType: String
  
  @Field(key: "shipping_cost")
  var shippingCost: Int
  
  @Field(key: "shipping_estimated_days")
  var shippingEstimatedDays: String
    
    @Field(key: "payment_method_type")
    var paymentMethodType: String
    
    @Field(key: "payment_method_bank")
    var paymentMethodBank: String?
    
    @Field(key: "payment_details_amount")
    var paymentDetailsAmount: Int
    
    @Field(key: "payment_details_virtual_account")
    var paymentDetailsVirtualAccount: String?
    
    @Field(key: "payment_details_expiry_date")
    var paymentDetailsExpiryDate: Date?
    
    @Field(key: "total")
    var total: Int
    
    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?
    
    @Timestamp(key: "updated_at", on: .update)
    var updatedAt: Date?
    
    @Children(for: \.$order)
    var items: [OrderItem]
    
    init() {}
    
    init(
        id: UUID? = nil,
        userId: UUID,
        status: String,
        shippingAddress: String,
        shippingType: String,
               shippingCost: Int,
               shippingEstimatedDays: String,
        paymentMethodType: String,
        paymentMethodBank: String? = nil,
        paymentDetailsAmount: Int,
        paymentDetailsVirtualAccount: String? = nil,
        paymentDetailsExpiryDate: Date? = nil,
        total: Int
    ) {
        self.id = id
        self.$user.id = userId
        self.status = status
        self.shippingAddress = shippingAddress
      self.shippingType = shippingType
             self.shippingCost = shippingCost
             self.shippingEstimatedDays = shippingEstimatedDays
        self.paymentMethodType = paymentMethodType
        self.paymentMethodBank = paymentMethodBank
        self.paymentDetailsAmount = paymentDetailsAmount
        self.paymentDetailsVirtualAccount = paymentDetailsVirtualAccount
        self.paymentDetailsExpiryDate = paymentDetailsExpiryDate
        self.total = total
    }
}
