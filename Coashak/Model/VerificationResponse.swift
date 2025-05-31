//
//  VerificationResponse.swift
//  Coashak
//
//  Created by Mohamed Magdy on 31/05/2025.
//


struct VerificationResponse: Codable {
    let message: String
    let user: User
    let role: String
}