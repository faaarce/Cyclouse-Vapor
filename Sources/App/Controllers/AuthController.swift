//
//  File.swift
//  Cyclouse
//
//  Created by yoga arie on 22/03/25.
//

// Sources/App/Controllers/AuthController.swift
import Vapor
import Fluent

struct AuthController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let auth = routes.grouped("auth")
        auth.post("register", use: register)
        auth.post("login", use: login)
      auth.post("logout", use: logout)
      
      
      auth.post("forgot-password", use: forgotPassword)
             auth.post("verify-code", use: verifyOTP)
             auth.post("reset-password", use: resetPassword)
    }
    
    func register(req: Request) async throws -> Response {
        try UserRegisterRequest.validate(content: req)
        let registerRequest = try req.content.decode(UserRegisterRequest.self)
        
        // Check if password and confirmPassword match
        guard registerRequest.password == registerRequest.confirmPassword else {
            throw Abort(.badRequest, reason: "Passwords do not match")
        }
        
        // Check if user with the same email already exists
        if try await User.query(on: req.db)
            .filter(\.$email == registerRequest.email)
            .first() != nil {
            throw Abort(.conflict, reason: "User with this email already exists")
        }
        
        // Hash the password
        let hashedPassword = try Bcrypt.hash(registerRequest.password)
        
        // Create and save new user
        let user = User(
            name: registerRequest.name,
            email: registerRequest.email,
            phone: registerRequest.phone,
            password: hashedPassword
        )
        
        try await user.save(on: req.db)
        
        // Create user cart
        let cart = Cart(userId: user.id!)
        try await cart.save(on: req.db)
        
        // Generate JWT token
        let payload = try AuthPayload(
            subject: user.id!.uuidString,
            expiration: .init(value: Date().addingTimeInterval(86400)) // 24 hours
        )
        
        let token = try req.application.jwt.signers.sign(payload)
        
        // Create response
        let response = Response(status: .ok)
//      response.headers.add(name: "Authorization", value: "Bearer \(token)")
        response.headers.bearerAuthorization = BearerAuthorization(token: token)
        
      try response.content.encode(AuthResponse.registered(
            userId: user.id!.uuidString,
            email: user.email,
            phone: user.phone ?? "",
            name: user.name
        ))
        return response
    }
    
    func login(req: Request) async throws -> Response {
        try UserLoginRequest.validate(content: req)
        let loginRequest = try req.content.decode(UserLoginRequest.self)
        
        guard let user = try await User.query(on: req.db)
            .filter(\.$email == loginRequest.email)
            .first() else {
            throw Abort(.unauthorized, reason: "Invalid credentials")
        }
        
        guard try Bcrypt.verify(loginRequest.password, created: user.password) else {
            throw Abort(.unauthorized, reason: "Invalid credentials")
        }
        
        // Generate JWT token
        let payload = try AuthPayload(
            subject: user.id!.uuidString,
            expiration: .init(value: Date().addingTimeInterval(86400)) // 24 hours
        )
        
        let token = try req.application.jwt.signers.sign(payload)
        
        // Create response
        let response = Response(status: .ok)
        response.headers.bearerAuthorization = BearerAuthorization(token: token)
        
      try response.content.encode(AuthResponse.loggedIn(
             userId: user.id!.uuidString,
             email: user.email,
             phone: user.phone ?? "",
             name: user.name
         ))
        
        return response
    }
  
   func logout(req: Request) async throws -> Response {
         guard let authHeader = req.headers.first(name: .authorization),
               authHeader.hasPrefix("Bearer ") else {
             throw Abort(.unauthorized, reason: "Missing or invalid Authorization header")
         }

         let token = String(authHeader.dropFirst(7)) // Remove "Bearer " prefix

         // Invalidate the token (e.g., add it to a blacklist)
         TokenBlacklist.shared.invalidateToken(token)

         // Return a response indicating the user has been logged out successfully
         let response = Response(status: .ok)
         try response.content.encode(AuthResponse(
             success: true,
             message: "Logged out successfully",
             userId: "",
             email: "",
             phone: "",
             name: ""
         ))

         return response
     }
}

// Add these methods to your existing AuthController

extension AuthController {
    
    func forgotPassword(req: Request) async throws -> SimpleResponse {
        try ForgotPasswordRequest.validate(content: req)
        let forgotRequest = try req.content.decode(ForgotPasswordRequest.self)
        
        // Check if user exists
        guard try await User.query(on: req.db)
            .filter(\.$email == forgotRequest.email)
            .first() != nil else {
            throw Abort(.notFound, reason: "User with this email not found")
        }
        
        // Generate OTP (always "123456")
        let otp = OTPService.shared.generateOTP(for: forgotRequest.email)
        
        req.logger.info("OTP for \(forgotRequest.email): \(otp)")
        
        return SimpleResponse(
            success: true,
            message: "Verification code sent. Use: 1234"
        )
    }
    
    func verifyOTP(req: Request) async throws -> SimpleResponse {
        try VerifyOTPRequest.validate(content: req)
        let verifyRequest = try req.content.decode(VerifyOTPRequest.self)
        
        // Verify OTP
        guard OTPService.shared.verifyOTP(email: verifyRequest.email, code: verifyRequest.code) else {
            throw Abort(.badRequest, reason: "Invalid verification code. Use: 1234")
        }
        
        return SimpleResponse(
            success: true,
            message: "Code verified successfully"
        )
    }
    
    func resetPassword(req: Request) async throws -> SimpleResponse {
        try ResetPasswordRequest.validate(content: req)
        let resetRequest = try req.content.decode(ResetPasswordRequest.self)
        
        // Verify OTP again
        guard OTPService.shared.verifyOTP(email: resetRequest.email, code: resetRequest.code) else {
            throw Abort(.badRequest, reason: "Invalid verification code. Use: 1234")
        }
        
        // Find user
        guard let user = try await User.query(on: req.db)
            .filter(\.$email == resetRequest.email)
            .first() else {
            throw Abort(.notFound, reason: "User not found")
        }
        
        // Hash new password
        let hashedPassword = try Bcrypt.hash(resetRequest.newPassword)
        
        // Update password
        user.password = hashedPassword
        try await user.save(on: req.db)
        
        // Remove OTP
        OTPService.shared.removeOTP(for: resetRequest.email)
        
        return SimpleResponse(
            success: true,
            message: "Password reset successfully"
        )
    }
}

