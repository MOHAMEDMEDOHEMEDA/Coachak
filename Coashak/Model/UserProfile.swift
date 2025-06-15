//
//  UserProfile.swift
//  Coashak
//
//  Created by Mohamed Magdy on 13/06/2025.
//


struct UserProfile: Codable, Identifiable {
    let id: String
    let firstName: String
    let lastName: String
    let email: String
    let dateOfBirth: String
    let phoneNumber: String
    let isVerified: Bool
    let pendingPasswordChange: Bool
    let profilePhoto: String
    let role: String
    let healthCondition: [String]
    let allergy: [String]
    let createdAt: String
    let updatedAt: String
    let fitnessGoal: String
    let fitnessLevel: String
    let height: Int
    let weight: Int
    let gender: String

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case firstName, lastName, email, dateOfBirth, phoneNumber,
             isVerified, pendingPasswordChange, profilePhoto,
             role, healthCondition, allergy, createdAt, updatedAt,
             fitnessGoal, fitnessLevel, height, weight, gender
    }
}

struct UserProfileResponse: Codable {
    let message: String
    let user: UserProfile
}
