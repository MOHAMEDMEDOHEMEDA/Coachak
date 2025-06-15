//
//  TrainerPlansViewModel.swift
//  Coashak
//
//  Created by Mohamed Magdy on 14/06/2025.
//


import Foundation

@MainActor
class TrainerPlansViewModel: ObservableObject {
    @Published var plans: [PlanClientsForResponse] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    func fetchPlans(for trainerId: String) {
        guard let url = URL(string: "https://coachak-backendend.onrender.com/api/v1/trainers/\(trainerId)/plans") else {
            self.errorMessage = "Invalid URL"
            print("❌ Invalid URL")
            return
        }

        print("🌐 Fetching plans from: \(url.absoluteString)")

        isLoading = true
        errorMessage = nil

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        // Add token if needed
        if let token = UserDefaults.standard.string(forKey: "access_token") {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            print("🔑 Added Authorization header")
        } else {
            print("⚠️ No access token found")
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
                    self.errorMessage = "No data returned"
                    print("❌ No data returned from API")
                    return
                }

                // Print raw response data for inspection
                if let jsonString = String(data: data, encoding: .utf8) {
                    print("📦 Raw JSON Response:\n\(jsonString)")
                }

                do {
                    let decoded = try JSONDecoder().decode(PlansResponse.self, from: data)
                    self.plans = decoded.plan
                    print("✅ Decoded plans: \(decoded.plan.count) plans found")
                } catch {
                    self.errorMessage = "Failed to decode: \(error.localizedDescription)"
                    print("❌ Decoding error: \(error.localizedDescription)")
                }
            }
        }.resume()
    }
}
