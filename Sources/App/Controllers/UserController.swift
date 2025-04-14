//
//  File.swift
//  Cyclouse
//
//  Created by yoga arie on 22/03/25.
//
// Sources/App/Controllers/UserController.swift
import Vapor
import Fluent

struct UserController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let users = routes.grouped("user")
        
        // Protected routes
        let protected = users.grouped(JWTAuthenticator())
        protected.get(":userId", "profile", use: getProfile)
        protected.put(":userId", "profile", use: updateProfile)
    }
    
  func getProfile(req: Request) async throws -> UserProfileResponse {
      // Verify JWT token
      let payload = try req.auth.require(AuthPayload.self)
      guard let tokenUserId = UUID(payload.sub.value) else {
          throw Abort(.badRequest, reason: "Invalid user ID in token")
      }
      
      // Get user ID from URL params
      guard let userIdParam = req.parameters.get("userId"),
            let userId = UUID(userIdParam) else {
          throw Abort(.badRequest, reason: "Invalid user ID parameter")
      }
      
      // Ensure the token user matches the requested profile
      guard tokenUserId == userId else {
          throw Abort(.forbidden, reason: "You can only access your own profile")
      }
      
      // Fetch the user
      guard let user = try await User.find(userId, on: req.db) else {
          throw Abort(.notFound, reason: "User not found")
      }
      
      // Create and return the response using the defined structures
      return UserProfileResponse(
          success: true,
          message: "Profile retrieved successfully",
          data: UserProfileData(
              id: user.id!.uuidString,
              name: user.name,
              email: user.email,
              phone: user.phone
          )
      )
  }

  // Update user profile
  func updateProfile(req: Request) async throws -> UserProfileResponse {
      // Verify JWT token
      let payload = try req.auth.require(AuthPayload.self)
      guard let tokenUserId = UUID(payload.sub.value) else {
          throw Abort(.badRequest, reason: "Invalid user ID in token")
      }
      
      // Get user ID from URL params
      guard let userIdParam = req.parameters.get("userId"),
            let userId = UUID(userIdParam) else {
          throw Abort(.badRequest, reason: "Invalid user ID parameter")
      }
      
      // Ensure the token user matches the requested profile
      guard tokenUserId == userId else {
          throw Abort(.forbidden, reason: "You can only update your own profile")
      }
      
      // Validate request
      try UserProfileUpdateRequest.validate(content: req)
      let updateRequest = try req.content.decode(UserProfileUpdateRequest.self)
      
      // Find user
      guard let user = try await User.find(userId, on: req.db) else {
          throw Abort(.notFound, reason: "User not found")
      }
      
      // Check if email is being changed and if it's already taken
      if updateRequest.email != user.email {
          if try await User.query(on: req.db)
              .filter(\.$email == updateRequest.email)
              .filter(\.$id != userId)
              .first() != nil {
              throw Abort(.conflict, reason: "Email is already in use")
          }
      }
      
      // Update user
      user.name = updateRequest.name
      user.email = updateRequest.email
      user.phone = updateRequest.phone
      
      try await user.save(on: req.db)
      
      // Create and return the response using the defined structures
      return UserProfileResponse(
          success: true,
          message: "Profile updated successfully!",
          data: UserProfileData(
              id: user.id!.uuidString,
              name: user.name,
              email: user.email,
              phone: user.phone
          )
      )
  }
}

// Define response structures that conform to Content
struct UserProfileResponse: Content {
    let success: Bool
    let message: String
    let data: UserProfileData
}

struct UserProfileData: Content {
    let id: String
    let name: String
    let email: String
    let phone: String
    // Password intentionally excluded for security
}
