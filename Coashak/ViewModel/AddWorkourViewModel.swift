//
//  ExercisesViewModel.swift
//  Coashak
//
//  Created by Mohamed Magdy on 12/06/2025.
//

import Foundation
import SwiftUI

@MainActor
class AddWorkoutViewModel: ObservableObject {
    @Published var errorMessage = ""
    
    func addWorkout(toDayPlanId dayPlanId: String, name: String) async {
        guard let url = URL(string: "https://coachak-backendend.onrender.com/api/v1/day-plans/\(dayPlanId)/workouts") else {
            errorMessage = "Invalid URL"
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let payload = ["name": name]
        
        do {
            request.httpBody = try JSONEncoder().encode(payload)
            
            let (data, response) = try await URLSession.shared.data(for: request)
            
            if let httpResponse = response as? HTTPURLResponse, !(200...299).contains(httpResponse.statusCode) {
                errorMessage = "Server error: \(httpResponse.statusCode)"
                return
            }
            
            let result = try JSONDecoder().decode(AddWorkoutResponse.self, from: data)
            print("Workout Added: \(result.dayPlan)")
            
        } catch {
            errorMessage = "Failed to add workout: \(error.localizedDescription)"
        }
    }
}
