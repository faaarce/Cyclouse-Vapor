//
//  File.swift
//  Cyclouse
//
//  Created by yoga arie on 29/09/24.
//

import Vapor

struct AuthMiddleware: AsyncMiddleware {
  func respond(to request: Request, chainingTo next: AsyncResponder) async throws -> Response {
    guard let authHeader = request.headers.first(name: .authorization) else {
      throw Abort(.unauthorized, reason: "Missing Authentication header")
    }
    
    if TokenBlacklist.shared.isTokenInvalid(authHeader) {
      throw Abort(.unauthorized, reason: "Token is no longer valid")
    }
    
    guard let authData = Data(base64Encoded: authHeader),
          let authInfo = try? JSONDecoder().decode(AuthInfo.self, from: authData) else {
      throw Abort(.unauthorized, reason: "Invalid Authentication header")
    }
    
    if authInfo.expires < Date() {
      throw Abort(.unauthorized, reason: "Authentication expired")
    }
    
    // If we get here, the authentication is valid
    request.auth.login(authInfo)
    
    return try await next.respond(to: request)
  }
}
