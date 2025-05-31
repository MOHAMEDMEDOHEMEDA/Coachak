//
//  TraineeProfile.swift
//  Coashak
//
//  Created by Mohamed Magdy on 12/05/2025.
//

import Foundation


// MARK: - Data Model for Trainee
struct TraineeProfile: Identifiable {
    let id = UUID()
    let photoPlaceholder: String  
    let name: String
    let age: Int
    let fitnessLevel: String
    let goal: String
    let weight: String // e.g., "60 KG"
    let height: String // e.g., "170 cm"
    let caloriesPerDay: String // e.g., "1700 cal"
    let healthConditions: [String]
    let allergies: [String]
}
