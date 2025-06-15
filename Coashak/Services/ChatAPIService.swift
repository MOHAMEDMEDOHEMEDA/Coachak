//
//  ChatMessageRequest.swift
//  Coashak
//
//  Created by Mohamed Magdy on 08/06/2025.
//



import Foundation

final class ChatAPIService {
    static let shared = ChatAPIService()
    private init() {}

    private let baseURL = URL(string: "http://localhost:8000")!

    private var jwtToken: String? {
        UserDefaults.standard.string(forKey: "access_token_AI")
    }

    private var jsonHeader: [String: String] {
        guard let token = jwtToken, !token.isEmpty else { return [:] }
        return [
            "Authorization": "Bearer \(token)",
            "Content-Type": "application/json"
        ]
    }

    enum APIServiceError: Error {
        case missingToken
        case decodingFailed
    }

    func sendMessage(request: ChatMessageRequest) async throws -> (reply: String, session_id: String) {
        guard !jsonHeader.isEmpty else {
            print("[ChatAPIService] ❌ Missing token.")
            throw APIServiceError.missingToken
        }

        let endpoint = URL(string: "/chat/message", relativeTo: baseURL)!
        var urlRequest = URLRequest(url: endpoint)
        urlRequest.httpMethod = "POST"
        jsonHeader.forEach { urlRequest.setValue($0.value, forHTTPHeaderField: $0.key) }

        let encodedBody = try JSONEncoder().encode(request)
        urlRequest.httpBody = encodedBody

        print("[ChatAPIService] 📤 Sending message to \(endpoint)")
        print("[ChatAPIService] 🧾 Headers: \(jsonHeader)")
        print("[ChatAPIService] 🧾 Body: \(String(data: encodedBody, encoding: .utf8) ?? "Invalid JSON")")

        let (data, response) = try await URLSession.shared.data(for: urlRequest)

        if let httpResponse = response as? HTTPURLResponse {
            print("[ChatAPIService] 🔄 Response status: \(httpResponse.statusCode)")
        }

        print("[ChatAPIService] 📥 Raw response data: \(String(data: data, encoding: .utf8) ?? "Unreadable")")

        guard let response = try? JSONDecoder().decode(ChatMessageResponse.self, from: data) else {
            print("[ChatAPIService] ❌ Decoding failed.")
            throw APIServiceError.decodingFailed
        }

        print("[ChatAPIService] ✅ Decoded response: reply = \(response.reply), session_id = \(response.session_id)")
        return (reply: response.reply, session_id: response.session_id)
    }

    func endSession(sessionID: String) async throws {
        guard !jsonHeader.isEmpty else {
            print("[ChatAPIService] ❌ Missing token.")
            throw APIServiceError.missingToken
        }

        let endpoint = URL(string: "/chat/end", relativeTo: baseURL)!
        var urlRequest = URLRequest(url: endpoint)
        urlRequest.httpMethod = "POST"
        jsonHeader.forEach { urlRequest.setValue($0.value, forHTTPHeaderField: $0.key) }

        let body = ["session_id": sessionID]
        let encodedBody = try JSONEncoder().encode(body)
        urlRequest.httpBody = encodedBody

        print("[ChatAPIService] 📤 Ending session \(sessionID)")
        print("[ChatAPIService] 🧾 Headers: \(jsonHeader)")
        print("[ChatAPIService] 🧾 Body: \(String(data: encodedBody, encoding: .utf8) ?? "Invalid JSON")")

        let (data, response) = try await URLSession.shared.data(for: urlRequest)

        if let httpResponse = response as? HTTPURLResponse {
            print("[ChatAPIService] 🔄 Response status: \(httpResponse.statusCode)")
        }

        print("[ChatAPIService] 📥 End session response: \(String(data: data, encoding: .utf8) ?? "Unreadable")")
    }

    func generateTestToken() async throws -> String {
        let url = URL(string: "/auth/generate-test-token", relativeTo: baseURL)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        print("[ChatAPIService] 🔐 Requesting test token from \(url)")

        let (data, response) = try await URLSession.shared.data(for: request)

        if let httpResponse = response as? HTTPURLResponse {
            print("[ChatAPIService] 🔄 Token response status: \(httpResponse.statusCode)")
        }

        print("[ChatAPIService] 📥 Raw token response: \(String(data: data, encoding: .utf8) ?? "Unreadable")")

        let decoded = try JSONDecoder().decode(TokenResponse.self, from: data)
        print("[ChatAPIService] ✅ Received token: \(decoded.access_token)")
        return decoded.access_token
    }
}
