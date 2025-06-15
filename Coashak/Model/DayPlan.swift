//
//  DayPlan.swift
//  Coashak
//
//  Created by Mohamed Magdy on 13/06/2025.
//


struct DayClientPlan: Codable, Identifiable {
    let id: String
    let day: String
    let meals: [MealEntry]?
    let workout: Workout?
    let version: Int

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case day
        case meals
        case workout
        case version = "__v"
    }
}

struct DayPlanResponse: Codable {
    let status: String
    let day: DayClientPlan
}
