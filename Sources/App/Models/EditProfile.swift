//
//  File.swift
//  Cyclouse
//
//  Created by yoga arie on 25/11/24.
//

import Vapor

// EditProfileRequest.swift
struct EditProfileRequest: Content {
    let name: String
    let phone: String
    let email: String
}

// EditProfileResponse.swift
struct EditProfileResponse: Content {
    let message: String
    let success: Bool
    let data: User
}
