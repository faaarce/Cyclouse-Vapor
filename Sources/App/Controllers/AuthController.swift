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
        
      try response.content.encode(AuthResponse(
                 success: true,
                 message: "User registered successfully!",
                 userId: user.id!.uuidString
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
        
        try response.content.encode(RegisterResponse(
          success: true,
          message: "User registered successfully!",
          userId: user.id!.uuidString
      ))
        
        return response
    }
}




