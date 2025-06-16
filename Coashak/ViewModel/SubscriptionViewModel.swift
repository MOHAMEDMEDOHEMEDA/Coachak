//
//  SubscriptionViewModel.swift
//  Coashak
//
//  Created by Mohamed Magdy on 12/06/2025.
//





import Foundation

@MainActor
class SubscriptionsViewModel: ObservableObject {
    @Published var subscriptions: [Subscription] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    func fetchSubscriptions() async {
        isLoading = true
        errorMessage = nil

        guard let url = URL(string: "https://coachak-backendend.onrender.com/api/v1/subscriptions") else {
            errorMessage = "Invalid URL"
            isLoading = false
            return
        }

        // Step 1: Retrieve the token from UserDefaults
        guard let accessToken = UserDefaults.standard.string(forKey: "access_token") else {
            errorMessage = "User not authenticated"
            isLoading = false
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        // Step 2: Set Authorization header
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")

        do {
            let (data, response) = try await URLSession.shared.data(for: request)

            // Optional: Check for status code
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
                errorMessage = "Server error: \(httpResponse.statusCode)"
                isLoading = false
                return
            }

            // Step 3: Decode
            let decoded = try JSONDecoder().decode(SubscriptionResponse.self, from: data)
            subscriptions = decoded.subscriptions
        } catch {
            errorMessage = "Failed to load subscriptions: \(error.localizedDescription)"
        }

        isLoading = false
    }
}
