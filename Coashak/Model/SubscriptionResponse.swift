//
//  SubscriptionResponse.swift
//  Coashak
//
//  Created by Mohamed Magdy on 14/06/2025.
//


import Foundation

struct SubscriptionClientResponse: Codable {
    let message: String
    let subscription: SubscriptionClient
}

struct SubscriptionClient: Codable, Identifiable {
    let _id: String
    let plan: String
    let client: String
    let trainer: String
    let status: String
    let trainingPlan: [String]
    let nutritionPlan: [String]
    let startedAt: String
    let expiresAt: String
    let createdAt: String
    let updatedAt: String
    let __v: Int?
    let active: Bool
    let daysUntilExpire: Int
    let id: String

    enum CodingKeys: String, CodingKey {
        case _id, plan, client, trainer, status, trainingPlan, nutritionPlan, startedAt, expiresAt, createdAt, updatedAt,__v, active, daysUntilExpire, id
    }
}


