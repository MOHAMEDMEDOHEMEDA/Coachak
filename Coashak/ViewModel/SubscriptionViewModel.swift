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

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoded = try JSONDecoder().decode(SubscriptionResponse.self, from: data)
            subscriptions = decoded.subscriptions
        } catch {
            errorMessage = "Failed to load subscriptions: \(error.localizedDescription)"
        }

        isLoading = false
    }
}

