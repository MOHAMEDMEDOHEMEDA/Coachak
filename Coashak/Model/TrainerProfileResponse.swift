//
//  ClientProfileResponse 2.swift
//  Coashak
//
//  Created by Mohamed Magdy on 10/06/2025.
//


// MARK: - Top-Level Response
import Foundation

struct TrainerProfileResponse: Codable {
    let message: String
    let user: TrainerUser?
}

struct TrainerUser: Codable, Identifiable {
    let id: String
    let firstName: String
    let lastName: String
    let email: String
    let password: String
    let dateOfBirth: Date
    let phoneNumber: String
    let gender: String?
    let isVerified: Bool
    let pendingPasswordChange: Bool
    let profilePhoto: String
    let role: String
    let availableDays: [String]
    let avgRating: String
    let createdAt: String
    let updatedAt: String
    let bio: String?
    let pricePerSession: Int?
    let yearsOfExperience: Int?
    let v: Int

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case firstName, lastName, email, password, dateOfBirth, phoneNumber, gender,
             isVerified, pendingPasswordChange, profilePhoto, role,
             availableDays, avgRating, createdAt, updatedAt, bio,
             pricePerSession, yearsOfExperience
        case v = "__v"
    }
}


