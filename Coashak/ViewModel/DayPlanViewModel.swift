//
//  DayPlanViewModel.swift
//  Coashak
//
//  Created by Mohamed Magdy on 13/06/2025.
//

import Foundation

@MainActor
class DayPlanViewModel: ObservableObject {
    @Published var dayPlan: DayClientPlan?
    @Published var isLoading = false
    @Published var errorMessage = ""
    
    func fetchTrainerDayPlan(clientId: String, weekNumber: Int, dayName: String) async {
        print("🔍 Starting fetchDayPlan with clientId: \(clientId), weekNumber: \(weekNumber), dayName: \(dayName)")
        
        defer {
            isLoading = false
            print("🔄 Finished fetchDayPlan call. isLoading set to false.")
        }
        
        guard let url = URL(string: "https://coachak-backendend.onrender.com/api/v1/weeks/\(weekNumber)/day-names/\(dayName)") else {
            errorMessage = "Invalid URL"
            print("❌ Invalid URL — fetch failed. errorMessage: \(errorMessage)")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POSt"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Payload body (clientId inside JSON body)
        let payload = ["client": clientId]
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: payload, options: [])
            print("📦 Request Body JSON: \(String(data: request.httpBody!, encoding: .utf8) ?? "nil")")
        } catch {
            errorMessage = "Failed to encode payload"
            print("❌ Payload Encoding Error: \(error.localizedDescription) — errorMessage: \(errorMessage)")
            return
        }
        
        do {
            isLoading = true
            let (data, response) = try await URLSession.shared.data(for: request)
            print("📡 Received Response from server.")
            
            if let httpResponse = response as? HTTPURLResponse {
                print("🌐 HTTP Status Code: \(httpResponse.statusCode)")
                if !(200...299).contains(httpResponse.statusCode) {
                    let errorData = String(data: data, encoding: .utf8) ?? "Unknown server error"
                    errorMessage = "Server error: \(httpResponse.statusCode) - \(errorData)"
                    print("❌ Server returned error — errorMessage: \(errorMessage)")
                    return
                }
            } else {
                print("❌ Response was not HTTPURLResponse.")
                errorMessage = "Invalid server response"
                return
            }
            
            print("✅ Received Data Size: \(data.count) bytes")
            if let jsonString = String(data: data, encoding: .utf8) {
                print("📄 JSON Response: \(jsonString)")
            } else {
                print("⚠️ Unable to convert data to JSON string.")
            }
            
            let result = try JSONDecoder().decode(DayPlanResponse.self, from: data)
            self.dayPlan = result.day
            self.errorMessage = ""
            
            print("🎯 Decoded Day Plan successfully: \(String(describing: self.dayPlan))")
            
        } catch {
            errorMessage = "Failed to load day plan: \(error.localizedDescription)"
            print("❌ Network or Decoding Error: \(error.localizedDescription) — errorMessage: \(errorMessage)")
        }
    }
    
    func fetchClientDayPlan(TrainerId: String, weekNumber: Int, dayName: String) async {
        print("🔍 Starting fetchDayPlan with clientId: \(TrainerId), weekNumber: \(weekNumber), dayName: \(dayName)")
        
        defer {
            isLoading = false
            print("🔄 Finished fetchDayPlan call. isLoading set to false.")
        }
        
        guard let url = URL(string: "https://coachak-backendend.onrender.com/api/v1/weeks/\(weekNumber)/day-names/\(dayName)") else {
            errorMessage = "Invalid URL"
            print("❌ Invalid URL — fetch failed. errorMessage: \(errorMessage)")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POSt"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Payload body (clientId inside JSON body)
        let payload = ["trainer": TrainerId]
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: payload, options: [])
            print("📦 Request Body JSON: \(String(data: request.httpBody!, encoding: .utf8) ?? "nil")")
        } catch {
            errorMessage = "Failed to encode payload"
            print("❌ Payload Encoding Error: \(error.localizedDescription) — errorMessage: \(errorMessage)")
            return
        }
        
        do {
            isLoading = true
            let (data, response) = try await URLSession.shared.data(for: request)
            print("📡 Received Response from server.")
            
            if let httpResponse = response as? HTTPURLResponse {
                print("🌐 HTTP Status Code: \(httpResponse.statusCode)")
                if !(200...299).contains(httpResponse.statusCode) {
                    let errorData = String(data: data, encoding: .utf8) ?? "Unknown server error"
                    errorMessage = "Server error: \(httpResponse.statusCode) - \(errorData)"
                    print("❌ Server returned error — errorMessage: \(errorMessage)")
                    return
                }
            } else {
                print("❌ Response was not HTTPURLResponse.")
                errorMessage = "Invalid server response"
                return
            }
            
            print("✅ Received Data Size: \(data.count) bytes")
            if let jsonString = String(data: data, encoding: .utf8) {
                print("📄 JSON Response: \(jsonString)")
            } else {
                print("⚠️ Unable to convert data to JSON string.")
            }
            
            let result = try JSONDecoder().decode(DayPlanResponse.self, from: data)
            self.dayPlan = result.day
            self.errorMessage = ""
            
            print("🎯 Decoded Day Plan successfully: \(String(describing: self.dayPlan))")
            
        } catch {
            errorMessage = "Failed to load day plan: \(error.localizedDescription)"
            print("❌ Network or Decoding Error: \(error.localizedDescription) — errorMessage: \(errorMessage)")
        }
    }
    func removeExercise(fromWorkout workoutId: String, exerciseId: String) async {
        // 1. Fetch JWT token
        guard let jwtToken = UserDefaults.standard.string(forKey: "access_token") else {
            print("JWT token not found in UserDefaults.")
            self.errorMessage = "Authorization failed."
            return
        }
        
        // 2. Build URL
        guard let url = URL(string: "https://coachak-backendend.onrender.com/api/v1/workouts/\(workoutId)/exercises/\(exerciseId)") else {
            print("Invalid URL")
            self.errorMessage = "Invalid request URL."
            return
        }
        
        // 3. Configure URLRequest
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue("Bearer \(jwtToken)", forHTTPHeaderField: "Authorization")
        
        // 4. Perform the request using async/await
        do {
            let (_, response) = try await URLSession.shared.data(for: request)
            
            // 5. Check HTTP response
            if let httpResponse = response as? HTTPURLResponse {
                if (200...299).contains(httpResponse.statusCode) {
                    print("Exercise removed successfully.")
                } else {
                    self.errorMessage = "Server error: \(httpResponse.statusCode)"
                    print("Server error: \(httpResponse.statusCode)")
                }
            } else {
                self.errorMessage = "Invalid server response."
                print("Invalid server response.")
            }
            
        } catch {
            self.errorMessage = "Request error: \(error.localizedDescription)"
            print("Request error: \(error.localizedDescription)")
        }
    }

}
