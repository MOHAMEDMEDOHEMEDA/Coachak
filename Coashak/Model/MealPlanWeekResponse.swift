//
//  MealPlanWeekResponse.swift
//  Coashak
//
//  Created by Mohamed Magdy on 12/06/2025.
//


import Foundation

struct MealPlanWeekResponse: Codable {
    let status: String
    let data: MealPlanWeek
}

struct MealPlanWeek: Codable {
    let id: String
    let subscription: String
    let weekNumber: Int
    let days: MealPlanDays
    let v: Int

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case subscription
        case weekNumber
        case days
        case v = "__v"
    }
}

struct MealPlanDays: Codable {
    let sunday: DayMeals
    let monday: DayMeals
    let tuesday: DayMeals
    let wednesday: DayMeals
    let thursday: DayMeals
    let friday: DayMeals
    let saturday: DayMeals
}

struct DayMeals: Codable {
    let id: String
    let meals: [MealForWeek]

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case meals
    }
}

struct MealForWeek: Codable {
    // Add fields once you know the meal structure, placeholder:
}
