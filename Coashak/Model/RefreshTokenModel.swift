//
//  RefreshTokenRequest.swift
//  Coashak
//
//  Created by Mohamed Magdy on 01/06/2025.
//


struct RefreshTokenRequest: Codable {
    let refreshToken: String
}

struct RefreshTokenResponse: Codable {
    let accessToken: String
}