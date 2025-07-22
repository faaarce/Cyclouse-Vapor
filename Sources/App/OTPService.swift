//
//  File.swift
//  Cyclouse
//
//  Created by yoga arie on 24/06/25.


import Vapor
// Sources/App/Services/OTPService.swift
import Vapor

final class OTPService {
    static let shared = OTPService()
    
    // Only store OTP code and expiry
    private var otpStorage: [String: (code: String, expiresAt: Date)] = [:]
    
    private init() {}
    
    func generateOTP(for email: String) -> String {
        // Always use fixed OTP for development
        let fixedOTP = "1234"
        
        // Store with 10 minute expiration
        let expiresAt = Date().addingTimeInterval(600)
        otpStorage[email] = (code: fixedOTP, expiresAt: expiresAt)
        
        return fixedOTP
    }
    
    func verifyOTP(email: String, code: String) -> Bool {
        // Check if OTP exists and not expired
        guard let stored = otpStorage[email],
              Date() < stored.expiresAt,
              stored.code == code else {
            return false
        }
        
        return true
    }
    
    func removeOTP(for email: String) {
        otpStorage.removeValue(forKey: email)
    }
}
