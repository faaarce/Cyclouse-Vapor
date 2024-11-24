//
//  File.swift
//  Cyclouse
//
//  Created by yoga arie on 29/09/24.
//

import Vapor

struct AuthController {
    static func login(req: Request) async throws -> Response {
        let loginRequest = try req.content.decode(LoginRequest.self)
        
        // Check if the email and password match the hardcoded user
        guard let user = users.first(where: { $0.email == loginRequest.email && $0.password == loginRequest.password }) else {
            throw Abort(.unauthorized, reason: "Invalid credentials")
        }
        
        // Create AuthInfo
        let authInfo = AuthInfo(
            userId: user.id,
            expires: Date().addingTimeInterval(86400), // 1 day from now
            email: user.email
        )
        
        // Convert AuthInfo to JSON and then to base64
        let jsonEncoder = JSONEncoder()
        jsonEncoder.dateEncodingStrategy = .secondsSince1970
        let authInfoData = try jsonEncoder.encode(authInfo)
        let authInfoBase64 = authInfoData.base64EncodedString()
        
        // Create response
        let response = Response(status: .ok)
        response.headers.add(name: "Authorization", value: authInfoBase64)
        
      let loginResponse = LoginResponse(message: "User signed in successfully!", success: true, userId: user.id, name: user.name)
        try response.content.encode(loginResponse)
        
        return response
    }
}
// Hardcoded users
var users: [User] = [
  User(id: UUID(), name: "fufufafa", email: "user@example.com", phone: "5551234", password: "password123")
]


extension AuthController {
    static func logout(req: Request) async throws -> Response {
        guard let authHeader = req.headers.first(name: .authorization) else {
            throw Abort(.unauthorized, reason: "Missing Authentication header")
        }
        
        // Add the token to the blacklist
        TokenBlacklist.shared.invalidateToken(authHeader)
        
        let response = Response(status: .ok)
        let logoutResponse = APIResponse<String>(success: true, message: "Logged out successfully", data: nil)
        try response.content.encode(logoutResponse)
        
        return response
    }
}

extension AuthController {
    static func register(req: Request) async throws -> Response {
        let registerRequest = try req.content.decode(RegisterRequest.self)

        // Validate that passwords match
        guard registerRequest.password == registerRequest.confirmPassword else {
            throw Abort(.badRequest, reason: "Passwords do not match")
        }

        // Check if user already exists
        if users.contains(where: { $0.email == registerRequest.email }) {
            throw Abort(.badRequest, reason: "User with this email already exists")
        }

        // Create new user
        let newUser = User(
            id: UUID(),
            name: registerRequest.name,
            email: registerRequest.email,
            phone: registerRequest.phone,
            password: registerRequest.password // In production, hash the password
        )

        // Add user to users array
        users.append(newUser)

        // Create AuthInfo
        let authInfo = AuthInfo(
            userId: newUser.id,
            expires: Date().addingTimeInterval(86400), // 1 day from now
            email: newUser.email
        )

        // Convert AuthInfo to JSON and then to base64
        let jsonEncoder = JSONEncoder()
        jsonEncoder.dateEncodingStrategy = .secondsSince1970
        let authInfoData = try jsonEncoder.encode(authInfo)
        let authInfoBase64 = authInfoData.base64EncodedString()

        // Create response
        let response = Response(status: .ok)
        response.headers.add(name: "Authorization", value: authInfoBase64)

      let registerResponse = RegisterResponse(message: "User registered successfully!", success: true, userId: newUser.id)
        try response.content.encode(registerResponse)

        return response
    }
}

extension AuthController {
    static func getUser(req: Request) async throws -> User {
        guard let userIdStr = req.parameters.get("userId"), let userId = UUID(uuidString: userIdStr) else {
            throw Abort(.badRequest, reason: "Invalid user ID")
        }

        guard let user = users.first(where: { $0.id == userId }) else {
            throw Abort(.notFound, reason: "User not found")
        }

        return user
    }
}
