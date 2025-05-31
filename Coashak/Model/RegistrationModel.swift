//
//  RegistrationModel.swift
//  Coashak
//
//  Created by Mohamed Magdy on 16/12/2024.
//

import Foundation

struct RegistrationRequest: Codable {
    let email: String
    let firstName: String
    let lastName: String
    let phoneNumber: String
    let dateOfBirth: Date
    let role: String
    let password: String
    let confirmPassword: String
}

