//
//  ChatViewModel.swift
//  Coashak
//
//  Created by Mohamed Magdy on 08/06/2025.
//


import Foundation
import SwiftUI

@MainActor
class ChatViewModel: ObservableObject {
    @Published var messages: [ChatMessage] = []
    @Published var sessionID: String?
    @Published var isLoading = false

    func sendMessage(_ text: String) async {
        guard !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }

        messages.append(ChatMessage(text: text, isUser: true))
        isLoading = true

        do {
            // Step 1: Get test token
            let token = try await ChatAPIService.shared.generateTestToken()
            UserDefaults.standard.set(token, forKey: "access_token_AI")

            // Step 2: Get user info from UserDefaults
            let defaults = UserDefaults.standard
            let user = ChatUser(
                firstName: defaults.string(forKey: "full_name") ?? "",
                lastName: defaults.string(forKey: "last_name") ?? "",
                weight: defaults.integer(forKey: "weight"),
                weightGoal: 0, // You can store and fetch this too if needed
                height: defaults.integer(forKey: "height"),
                job: "", // Optional: Store/fetch job if needed
                fitnessLevel: defaults.string(forKey: "fitness_level"), // Optional: Customize this per user
                fitnessGoal: defaults.string(forKey: "fitness_goal"), // Optional
                healthCondition: defaults.string(forKey: "health_condition") ?? "",
                alergy: defaults.string(forKey: "allergies") ?? ""
            )

            // Step 3: Construct chat request
            let request = ChatMessageRequest(
                message: text,
                user_id: sessionID == nil ? "\(defaults.integer(forKey: "id"))" : nil,
                user: sessionID == nil ? user : nil,
                session_id: sessionID
            )

            // Step 4: Send request
            let response = try await ChatAPIService.shared.sendMessage(request: request)
            sessionID = response.session_id
            messages.append(ChatMessage(text: response.reply, isUser: false))
        } catch {
            messages.append(ChatMessage(text: "Error: \(error.localizedDescription)", isUser: false))
        }

        isLoading = false
    }

    func endChat() async {
        guard let sessionID else { return }
        try? await ChatAPIService.shared.endSession(sessionID: sessionID)
        self.sessionID = nil
        self.messages.removeAll()
    }
}
