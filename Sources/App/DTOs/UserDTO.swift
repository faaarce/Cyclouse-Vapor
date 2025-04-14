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
