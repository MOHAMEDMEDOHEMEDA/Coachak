//
//  SignUpResponse.swift
//  Coashak
//
//  Created by Mohamed Magdy on 16/01/2025.
//

import Foundation

struct RegistrationAndLoginSuccessResponse: Decodable {
    let message: String
    let data: RegistrationData
}

struct RegistrationData: Decodable {
    let user: User
    let accessToken: String
    let refreshToken: String
}
