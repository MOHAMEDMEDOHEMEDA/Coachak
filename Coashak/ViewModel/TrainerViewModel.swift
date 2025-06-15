//
//  TrainerViewModel.swift
//  Coashak
//
//  Created by Mohamed Magdy on 14/06/2025.
//


import Foundation
import Combine


@MainActor
class TrainerForClientsProfileViewModel: ObservableObject {
    @Published var trainer: TrainerForClientsProfile?
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    func fetchTrainerProfile(trainerId: String) {
        guard let url = URL(string: "https://coachak-backendend.onrender.com/api/v1/users/\(trainerId)") else {
            errorMessage = "Invalid URL"
            print("❌ Invalid URL")
            return
        }
        
        print("🌐 Fetching trainer profile from: \(url)")
        isLoading = true
        errorMessage = nil
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let token = UserDefaults.standard.string(forKey: "access_token") {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        } else {
            print("❌ Access token not found in UserDefaults")
            errorMessage = "Authentication token is missing."
            isLoading = false
            return
        }
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                self.isLoading = false
                
                if let error = error {
                    self.errorMessage = error.localizedDescription
                    print("❌ Network error: \(error.localizedDescription)")
                    return
                }
                
                guard let data = data else {
                    self.errorMessage = "No data received"
                    print("❌ No data received")
                    return
                }
                
                if let jsonString = String(data: data, encoding: .utf8) {
                    print("📦 JSON Response:\n\(jsonString)")
                }
                
                do {
                    let result = try JSONDecoder().decode(TrainerForClientsProfileResponse.self, from: data)
                    self.trainer = result.user
                    print("✅ Successfully decoded trainer: \(result.user.fullName)")
                } catch {
                    self.errorMessage = "Failed to decode trainer: \(error.localizedDescription)"
                    print("❌ Decoding error: \(error.localizedDescription)")
                }
            }
        }.resume()
    }
}
