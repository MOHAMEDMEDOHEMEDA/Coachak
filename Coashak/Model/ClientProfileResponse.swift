//
//  ClientProfileResponse.swift
//  Coashak
//
//  Created by Mohamed Magdy on 03/06/2025.
//

import Foundation

// MARK: - Top-Level Response
struct ClientProfileResponse: Codable {
    let message: String
    let user: ClientUser?
}

struct ClientUser: Codable, Identifiable {
    let id: String
    let firstName: String
    let lastName: String
    let email: String
    let password: String
    let dateOfBirth: Date
    let phoneNumber: String
    let isVerified: Bool
    let pendingPasswordChange: Bool
    let profilePhoto: String
    let role: String
    let healthCondition: [String]
    let allergy: [String]
    let createdAt: Date
    let updatedAt: Date
    let fitnessGoal: String?
    let gender: String?
    let fitnessLevel: String?
    let height: Int?
    let job: String?
    let weight: Int?
    let weightGoal: Int?
    let v: Int?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case firstName, lastName, email, password, dateOfBirth, phoneNumber, isVerified,
             pendingPasswordChange, profilePhoto, role, healthCondition, allergy,
             createdAt, updatedAt, fitnessGoal, gender, fitnessLevel, height, job, weight, weightGoal
        case v = "__v"
    }
}

// MARK: - JSON Decoder with custom date decoding

//func decodeClientProfileResponse(from data: Data) throws -> ClientProfileResponse {
//    let decoder = JSONDecoder()
//
//    let formatter = ISO8601DateFormatter()
//    formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
//
//    decoder.dateDecodingStrategy = .custom { decoder in
//        let container = try decoder.singleValueContainer()
//        let dateStr = try container.decode(String.self)
//
//        if let date = formatter.date(from: dateStr) {
//            return date
//        }
//
//        throw DecodingError.dataCorruptedError(in: container, debugDescription: "Cannot decode date string \(dateStr)")
//    }
//
//    return try decoder.decode(ClientProfileResponse.self, from: data)
//}
