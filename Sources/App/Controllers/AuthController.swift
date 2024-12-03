//
//  File.swift
//  Cyclouse
//
//  Created by yoga arie on 29/09/24.
//
import Fluent
import Vapor

struct AuthController {
    static func login(req: Request) async throws -> Response {
        let loginRequest = try req.content.decode(LoginRequest.self)
        
      // Fetch the user from the database
           guard let user = try await User.query(on: req.db)
               .filter(\.$email == loginRequest.email)
               .filter(\.$password == loginRequest.password)
               .first() else {
                   throw Abort(.unauthorized, reason: "Invalid credentials")
           }
        
        // Create AuthInfo
        let authInfo = AuthInfo(
          userId: user.id ?? UUID(),
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
        
      let loginResponse = LoginResponse(
            message: "User signed in successfully!",
            success: true,
            userId: user.id ?? UUID(),
            name: user.name,
            email: user.email,    // Added email
            phone: user.phone     // Added phone
        )
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
      
      if try await User.query(on: req.db)
               .filter(\.$email == registerRequest.email)
               .first() != nil {
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
      try await newUser.save(on: req.db)

        // Create AuthInfo
        let authInfo = AuthInfo(
          userId: newUser.id ?? UUID(),
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

      let registerResponse = RegisterResponse(message: "User registered successfully!", success: true, userId: newUser.id ?? UUID())
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

// Add to AuthController.swift
extension AuthController {
  static func updateProfile(req: Request) async throws -> Response {
    // Get user ID from parameters and verify it's valid
    guard let userIdStr = req.parameters.get("userId"),
          let userId = UUID(uuidString: userIdStr) else {
      throw Abort(.badRequest, reason: "Invalid user ID format")
    }
    
    // Decode the update request
    let updateRequest = try req.content.decode(EditProfileRequest.self)
    
    // Start a database transaction to ensure data consistency
    return try await req.db.transaction { database -> Response in
      // First, check if the user exists
      guard let user = try await User.find(userId, on: database) else {
        throw Abort(.notFound, reason: "User not found")
      }
      
      // If email is being changed, check if the new email is already taken
      if user.email != updateRequest.email {
        if try await User.query(on: database)
          .filter(\.$email == updateRequest.email)
          .first() != nil {
          throw Abort(.badRequest, reason: "Email address is already in use")
        }
      }
      
      // Update user fields
      user.name = updateRequest.name
      user.email = updateRequest.email
      user.phone = updateRequest.phone
      // Note: We keep the existing password
      
      // Save the updated user to database
      try await user.save(on: database)
      
      // Create success response
      let response = Response(status: .ok)
      let editResponse = EditProfileResponse(
        message: "Profile updated successfully!",
        success: true,
        data: user
      )
      try response.content.encode(editResponse)
      
      return response
    }
  }
  
}
