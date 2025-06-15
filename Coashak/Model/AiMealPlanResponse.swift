//
//  MealPlanResponse.swift
//  Coashak
//
//  Created by Mohamed Magdy on 02/06/2025.
//

struct MealPlanResponse: Codable { /* ... */
    let status: String
    let result: ResultData?
}

// Updated Similar Meal Response Structures
struct SimilarMealResponse: Codable {
    let status: String
    let result: [SimilarMealResultItem]?
}


struct SimilarMealResultItem: Codable, Identifiable {
    var id: String { name }

    let name: String
    let type: String
    let ingredients: [String]?
    let preparation: String?
    let nutrition: NutritionInfo?
    let similarityFactors: [String]

    enum CodingKeys: String, CodingKey {
        case name, type, ingredients, preparation, nutrition
        case similarityFactors = "similarity_factors"
    }
}

struct MealAi: Codable, Identifiable, Hashable {
    var id: String { name }
    let name: String
    let type: String
    let ingredients: [String]?
    let preparation: String?
    let nutrition: NutritionInfo?
    let imageURL: String?

    static func == (lhs: MealAi, rhs: MealAi) -> Bool { lhs.name == rhs.name }

    func hash(into hasher: inout Hasher) { hasher.combine(name) }

    enum CodingKeys: String, CodingKey {
        case name, type, ingredients, preparation, nutrition
        case imageURL = "image_url"
    }
}

struct ResultData: Codable {
    let dailyNutrition: NutritionInfo?
    let recommendation: Recommendation
    let evaluation: [String: Evaluation]?
    let totalEvaluation: TotalEvaluation?

    enum CodingKeys: String, CodingKey {
        case dailyNutrition = "daily_nutrition"
        case recommendation
        case evaluation
        case totalEvaluation = "total_evaluation"
    }
}

struct NutritionInfo: Codable {
    let BMI: Double?
    let calories: Int
    let proteinG: Int
    let fatsG: Int
    let carbsG: Int

    enum CodingKeys: String, CodingKey {
        case BMI
        case calories
        case proteinG = "protein_g"
        case fatsG = "fats_g"
        case carbsG = "carbs_g"
    }
}

struct Recommendation: Codable {
    let dailyNutrition: NutritionInfo?
    let days: [DayPlan]

    enum CodingKeys: String, CodingKey {
        case dailyNutrition = "daily_nutrition"
        case days
    }
}

struct DayPlan: Codable {
    let day: Int?
    let meals: [MealAi]
}


struct Evaluation: Codable {
    let calories: Int
    let proteinG: Int
    let fatG: Int
    let carbsG: Int
    let caloriesStatus: String
    let proteinStatus: String
    let fatStatus: String
    let carbsStatus: String

    enum CodingKeys: String, CodingKey {
        case calories
        case proteinG = "protein_g"
        case fatG = "fat_g"
        case carbsG = "carbs_g"
        case caloriesStatus = "calories_status"
        case proteinStatus = "protein_status"
        case fatStatus = "fat_status"
        case carbsStatus = "carbs_status"
    }
}

struct TotalEvaluation: Codable {
    let totalDays: Int
    let totalCalories: Int
    let totalProtein: Int
    let totalFat: Int
    let totalCarbs: Int
    let totalCaloriesStatus: String
    let totalProteinStatus: String
    let totalFatStatus: String
    let totalCarbsStatus: String

    enum CodingKeys: String, CodingKey {
        case totalDays = "total_days"
        case totalCalories = "total_calories"
        case totalProtein = "total_protein"
        case totalFat = "total_fat"
        case totalCarbs = "total_carbs"
        case totalCaloriesStatus = "total_calories_status"
        case totalProteinStatus = "total_protein_status"
        case totalFatStatus = "total_fat_status"
        case totalCarbsStatus = "total_carbs_status"
    }
}


