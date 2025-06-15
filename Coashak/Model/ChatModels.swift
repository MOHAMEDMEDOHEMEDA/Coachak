//
//  ChatMessageRequest.swift
//  Coashak
//
//  Created by Mohamed Magdy on 08/06/2025.
//
import Foundation

struct ChatMessageRequest: Codable {
    let message: String
    let user_id: String?
    let user: ChatUser?
    let session_id: String?
}

struct ChatUser: Codable {
    let firstName: String?
    let lastName: String?
    let weight: Int?
    let weightGoal: Int?
    let height: Int?
    let job: String?
    let fitnessLevel: String?
    let fitnessGoal: String?
    let healthCondition: String?
    let alergy: String?
}

struct ChatMessageResponse: Codable {
    let reply: String
    let session_id: String
}

struct ChatMessage: Identifiable {
    let id = UUID()
    let text: String
    let isUser: Bool
}

struct TokenResponse: Codable {
    let access_token: String
}
