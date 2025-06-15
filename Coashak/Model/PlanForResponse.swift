//
//  PlanForResponse.swift
//  Coashak
//
//  Created by Mohamed Magdy on 14/06/2025.
//


import Foundation

struct PlanClientsForResponse: Identifiable, Codable {
    let _id: String
    let trainer: String
    let title: String
    let description: String
    let price: Int
    let durationInWeeks: Int
    let hasTrainingPlan: Bool
    let hasNutritionPlan: Bool
    let createdAt: String
    let updatedAt: String
    let subscriptionCount: Int?
    let id: String


}

// Wrapper for decoding the outer response
struct PlansResponse: Codable {
    let message: String
    let plan: [PlanClientsForResponse]
}
