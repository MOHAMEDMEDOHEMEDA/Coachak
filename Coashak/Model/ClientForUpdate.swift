//
//  User 2.swift
//  Coashak
//
//  Created by Mohamed Magdy on 30/05/2025.
//


struct Client: Codable {
    let firstName: String
    let lastName: String
    let phoneNumber: String
    let profilePic: String
    let weight: Int
    let weightGoal: Int
    let height: Int
    let job: String
    let fitnessLevel: String
    let fitnessGoal: String
    let healthCondition: [String]
    let allergy: [String]
}
