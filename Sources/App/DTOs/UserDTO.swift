//
//  File.swift
//  Cyclouse
//
//  Created by yoga arie on 22/03/25.
//

import Vapor


struct UserRegisterRequest: Content, Validatable {
    let name: String
    let email: String
    let phone: String
    let password: String
    let confirmPassword: String
    
    static func validations(_ validations: inout Validations) {
        validations.add("name", as: String.self, is: !.empty)
        validations.add("email", as: String.self, is: .email)
        validations.add("phone", as: String.self, is: !.empty)
        validations.add("password", as: String.self, is: .count(8...))
        validations.add("confirmPassword", as: String.self, is: .count(8...))
    }
}

struct ForgotPasswordRequest: Content, Validatable {
    let email: String
    
    static func validations(_ validations: inout Validations) {
        validations.add("email", as: String.self, is: .email)
    }
}


struct VerifyOTPRequest: Content, Validatable {
    let email: String
    let code: String
    
    static func validations(_ validations: inout Validations) {
        validations.add("email", as: String.self, is: .email)
      validations.add("code", as: String.self, is: .count(2...4))
    }
}

struct VerifyOTPResponse: Content {
    let success: Bool
    let message: String
    let resetToken: String
}

struct ResetPasswordRequest: Content, Validatable {
    let email: String
    let code: String
    let newPassword: String
    
    static func validations(_ validations: inout Validations) {
        validations.add("email", as: String.self, is: .email)
        validations.add("code", as: String.self, is: .count(2...4))
        validations.add("newPassword", as: String.self, is: .count(8...))
       
    }
}

struct SimpleResponse: Content {
    let success: Bool
    let message: String
}

struct UserLoginRequest: Content, Validatable {
    let email: String
    let password: String
    
    static func validations(_ validations: inout Validations) {
        validations.add("email", as: String.self, is: .email)
        validations.add("password", as: String.self, is: !.empty)
    }
}

struct UserResponseDTO: Content {
    let id: UUID
    let name: String
    let email: String
    let phone: String
    
    init(user: User) {
        self.id = user.id!
        self.name = user.name
        self.email = user.email
        self.phone = user.phone
    }
}

struct UserProfileUpdateRequest: Content, Validatable {
    let name: String
    let email: String
    let phone: String
    
    static func validations(_ validations: inout Validations) {
        validations.add("name", as: String.self, is: !.empty)
        validations.add("email", as: String.self, is: .email)
        validations.add("phone", as: String.self, is: !.empty)
    }
}
