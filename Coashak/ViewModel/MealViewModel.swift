//
//  MealViewModel.swift
//  Coashak
//
//  Created by Mohamed Magdy on 13/06/2025.
//


import Foundation

@MainActor
class MealViewModel: ObservableObject {
    @Published var result: MealResponse?
    @Published var isLoading = false
    @Published var message = ""
    
    func addMeal(mealName: String, mealType: String, to dayId: String) async {
        print("Starting addMeal function")
        
        // Ensure isLoading is reset even if an error occurs
        defer {
            isLoading = false
            print("isLoading set to false in defer block")
        }

        guard let url = URL(string: "https://coachak-backendend.onrender.com/api/v1/day-plans/\(dayId)/meals") else {
            message = "Invalid URL"
            print("Invalid URL")
            return
        }
        
        print("URL created: \(url.absoluteString)")
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: String] = [
            "meal": mealName,
            "type": mealType
        ]
        
        print("Request Body: \(body)")

        do {
            isLoading = true
            print("isLoading set to true")

            request.httpBody = try JSONEncoder().encode(body)
            print("HTTP Body encoded")

            let (data, response) = try await URLSession.shared.data(for: request)
            print("Received response from server")

            if let httpResponse = response as? HTTPURLResponse {
                print("HTTP Status Code: \(httpResponse.statusCode)")
                if !(200...299).contains(httpResponse.statusCode) {
                    let errorData = String(data: data, encoding: .utf8) ?? "Unknown server error"
                    message = "Server error: \(httpResponse.statusCode) - \(errorData)"
                    print("Server error: \(message)")
                    return
                }
            }

            let result = try JSONDecoder().decode(MealResponse.self, from: data)
            self.message = result.message
            self.result = result
            print("Meal added successfully: \(result)")
            
        } catch {
            message = "Error adding meal: \(error.localizedDescription)"
            print("Catch error: \(error.localizedDescription)")
        }
    }
}
