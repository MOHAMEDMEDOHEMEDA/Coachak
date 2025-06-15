//
//  addExersisesViewModel.swift
//  Coashak
//
//  Created by Mohamed Magdy on 13/06/2025.
//


import Foundation

@MainActor
class AddExerciseViewModel: ObservableObject {
    @Published var errorMessage = ""
    
    func addExercise(toWorkoutId workoutId: String, exercise: ExerciseDetail, sets: Int, reps: Int, rest: Int, sortOrder: Int) async {
        guard let url = URL(string: "https://coachak-backendend.onrender.com/api/v1/workouts/\(workoutId)/exercises") else {
            errorMessage = "Invalid URL"
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // The API expects this payload structure:
        let payload: [String: Any] = [
            "exercise": exercise.name, // String name as per API request body you posted
            "sets": sets,
            "reps": reps,
            "rest": rest
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: payload, options: [])
            
            let (data, response) = try await URLSession.shared.data(for: request)
            
            if let httpResponse = response as? HTTPURLResponse, !(200...299).contains(httpResponse.statusCode) {
                errorMessage = "Server error: \(httpResponse.statusCode)"
                return
            }
            
            let result = try JSONDecoder().decode(UpdateWorkoutResponse.self, from: data)
            print("✅ Exercise Added to Workout: \(result.workout)")
            
        } catch {
            errorMessage = "❌ Failed to add exercise: \(error.localizedDescription)"
        }
    }
    
    

    
}
