//
//  TrainerForUpdateModel.swift
//  Coashak
//
//  Created by Mohamed Magdy on 09/06/2025.
//
import Foundation


// MARK: - Models

struct Trainer: Codable {
    let profilePic: String?
    let bio: String?
    let availableDays: [String]?
    let pricePerSession: Int?
    let yearsOfExperience: Int?
    let firstName: String?
    let lastName: String?
    let gender: String?
    let email: String?
    let birthday: Date?
}

struct TrainerForUpdate: Codable {
    let profilePic: String?
    let bio: String?
    let availableDays: [String]?
    let pricePerSession: Int?
    let yearsOfExperience: Int?
}
