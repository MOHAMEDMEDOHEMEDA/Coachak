//
//  AIMealRequestModel.swift
//  Coashak
//
//  Created by Mohamed Magdy on 02/06/2025.
//

struct AIMealRequest: Codable {
    var height_cm: Int
    var weight_kg: Int
    var age: Int
    var sex: String
    var workouts_per_week: Int
    var goal: String
    var exclude_ingredients: [String]
    var allergies: [String]
}

struct AIMealResponse: Codable { 
    var task_id: String
    var status: String
    var message: String?
}


