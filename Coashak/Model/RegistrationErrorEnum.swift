//
//  RegistrationErrorEnum.swift
//  Coashak
//
//  Created by Mohamed Magdy on 16/12/2024.
//

import Foundation

enum RegistrationError: LocalizedError {
    case decodingError
    case networkError
    case serverError(String)
    case unknownError

    var errorDescription: String? {
        switch self {
        case .decodingError:
            return "Failed to decode the response from the server."
        case .networkError:
            return "A network error occurred. Please try again."
        case .serverError(let message):
            return message
        case .unknownError:
            return "An unknown error occurred."
        }
    }
}

// This struct can decode the specific server error payload
struct RegistrationErrorResponse: Codable {
    let error: String
}
