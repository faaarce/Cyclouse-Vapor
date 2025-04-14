//
//  File.swift
//  Cyclouse
//
//  Created by yoga arie on 22/03/25.
//
// Sources/App/Models/AuthPayload.swift
import JWT
import Vapor

struct AuthPayload: JWTPayload, Authenticatable {
    var exp: ExpirationClaim
    var sub: SubjectClaim
    
    init(subject: String, expiration: ExpirationClaim) {
        self.sub = SubjectClaim(value: subject)
        self.exp = expiration
    }
    
    func verify(using signer: JWTSigner) throws {
        try exp.verifyNotExpired()
    }
}
