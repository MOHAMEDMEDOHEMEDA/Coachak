//
//  Plan.swift
//  Coashak
//
//  Created by Mohamed Magdy on 10/06/2025.
//

import Foundation

struct Plan: Codable, Identifiable {
    var id = UUID() // optional, for SwiftUI lists
    let title: String
    let description: String
    let price: Int
    let durationInWeeks: Int
    let hasNutritionPlan: Bool
    let hasTrainingPlan: Bool
}

struct PlanResponse: Codable {
    let message: String
    let plan: PlanForResponse
}

// Top-level response for GET plans
struct GetPlansResponse: Codable {
    let message: String
    let plan: [PlanForResponse]  // List of plans
}

// Individual plan model
struct PlanForResponse: Codable, Identifiable, Hashable {
    let id: String           // maps "_id"
    let trainer: String
    let title: String
    let description: String
    let price: Int
    let durationInWeeks: Int
    let hasTrainingPlan: Bool
    let hasNutritionPlan: Bool
    let createdAt: Date
    let updatedAt: Date
    let v: Int               // maps "__v"

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case trainer, title, description, price, durationInWeeks,
             hasTrainingPlan, hasNutritionPlan, createdAt, updatedAt
        case v = "__v"
    }
}


struct SubscriptionResponse: Codable {
    let subscriptions: [Subscription]
}

struct Subscription: Codable, Identifiable, Hashable {
    let id: String
    let status: String
    let trainingPlan: [String]?
    let nutritionPlan: [String]?
    let startedAt: String
    let expiresAt: String
    let createdAt: String
    let updatedAt: String
    let active: Bool
    let daysUntilExpire: Int
    let client: ClientSub
    let trainer: TrainerSub
    let plan: PlanSub

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case status
        case trainingPlan
        case nutritionPlan
        case startedAt
        case expiresAt
        case createdAt
        case updatedAt
        case active
        case daysUntilExpire
        case client
        case trainer
        case plan
    }
}

struct ClientSub: Codable, Hashable {
    let id: String
    let fullName: String
    let profilePhoto: String

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case fullName
        case profilePhoto
    }
}

struct TrainerSub: Codable, Hashable {
    let id: String
    let fullName: String

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case fullName
    }
}

struct PlanSub: Codable, Hashable {
    let id: String
    let title: String

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case title
    }
}
