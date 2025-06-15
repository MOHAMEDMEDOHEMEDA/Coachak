//
//  Workout.swift
//  Coashak
//
//  Created by Mohamed Magdy on 11/06/2025.
//

import Foundation

struct ExerciseDetail: Codable, Identifiable {
    let id: String
    let name: String

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name
    }
}

struct ExerciseWrapper: Codable, Identifiable {
    let id: String
    let exercise: ExerciseDetail
    let sortOrder: Int
    let sets: Int
    let reps: Int
    let rest: Int

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case exercise
        case sortOrder
        case sets
        case reps
        case rest
    }
}

struct Workout: Codable, Identifiable {
    let id: String
    let creator: String
    let name: String
    let exercises: [ExerciseWrapper]

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case creator
        case name
        case exercises
    }
}

struct UpdateWorkoutResponse: Codable {
    let message: String
    let workout: Workout
}

struct AddWorkoutResponse: Codable {
    let message: String
    let dayPlan: DayClientPlan
}

