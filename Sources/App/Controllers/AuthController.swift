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
        
        let loginResponse = LoginResponse(message: "User signed in successfully!", success: true)
        try response.content.encode(loginResponse)
        
        return response
    }
}
// Hardcoded users
let users: [User] = [
    User(id: UUID(), email: "user@example.com", password: "password123")
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
