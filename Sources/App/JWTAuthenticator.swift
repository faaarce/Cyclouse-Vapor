//
//  File.swift
//  Cyclouse
//
//  Created by yoga arie on 22/03/25.
//
// Sources/App/Auth/JWTAuthenticator.swift
import Vapor
import JWT

struct JWTAuthenticator: AsyncBearerAuthenticator {
    func authenticate(bearer: BearerAuthorization, for request: Request) async throws {
        do {
            let payload = try request.application.jwt.signers.verify(bearer.token, as: AuthPayload.self)
            
            // Check if token is blacklisted
            if TokenBlacklist.shared.isTokenInvalid(bearer.token) {
                throw Abort(.unauthorized, reason: "Token has been invalidated")
            }
            
            // Check if token is expired
            try payload.exp.verifyNotExpired()
            
            // Set authenticated payload
            request.auth.login(payload)
        } catch {
            throw Abort(.unauthorized, reason: "Invalid or expired token")
        }
    }
}
