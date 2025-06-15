//
//  TrainersResponse.swift
//  Coashak
//
//  Created by Mohamed Magdy on 14/06/2025.
//


import Foundation

// MARK: - TrainersResponse
struct TrainersResponse: Codable {
    let message: String
    let trainers: [TrainersForClients]
}

// MARK: - Trainer
struct TrainersForClients: Codable, Identifiable {
    let id: String
    let availableDays: [String]
    let avgRating: String
    let firstName: String
    let lastName: String
    let email: String
    let dateOfBirth: String
    let phoneNumber: String
    let pendingPasswordChange: Bool
    let profilePhoto: String
    let createdAt: String
    let updatedAt: String
    let v: Int

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case availableDays, avgRating, firstName, lastName, email, dateOfBirth, phoneNumber, pendingPasswordChange, profilePhoto, createdAt, updatedAt
        case v = "__v"
    }
}


struct TrainerForClientsProfile: Codable, Identifiable {
    let id: String
    let firstName: String
    let lastName: String
    let email: String
    let dateOfBirth: String
    let phoneNumber: String
    let isVerified: Bool
    let profilePhoto: String
    let role: String
    let availableDays: [String]
    let avgRating: String
    let bio: String?
    let pricePerSession: Int?
    let yearsOfExperience: Int?

    var fullName: String {
        return "\(firstName) \(lastName)"
    }

    private enum CodingKeys: String, CodingKey {
        case id = "_id"
        case firstName, lastName, email, dateOfBirth, phoneNumber,
             isVerified, profilePhoto, role, availableDays, avgRating,
             bio, pricePerSession, yearsOfExperience
    }
}


struct TrainerForClientsProfileResponse: Codable {
    let message: String
    let user: TrainerForClientsProfile
}
