//
//  Meal.swift
//  Coashak
//
//  Created by Mohamed Magdy on 13/06/2025.
//


// MARK: - Models

struct MealPlan: Codable, Identifiable {
    let id: String
    let name: String
    let creator: String
    let version: Int

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name
        case creator
        case version = "__v"
    }
}

struct MealEntry: Codable, Identifiable {
    let id: String
    let meal: MealPlan
    let type: String
    let order: Int?
    let day: String? // Made optional as it might not always be present in MealEntry context

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case meal
        case type
        case order
        case day
    }
}

struct MealResponse: Codable {
    let message: String
    let meal: MealEntry
}
