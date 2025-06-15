//
//  User 2.swift
//  Coashak
//
//  Created by Mohamed Magdy on 30/05/2025.
//


struct Client: Codable {
    let gender: String?
    let profilePic: String
    let weight: Int
    let height: Int
    let fitnessLevel: FitnessLevel.RawValue
    let fitnessGoal: String
    let goalweight: Int?
    let healthCondition: [String]
    let allergy: [String]
}
