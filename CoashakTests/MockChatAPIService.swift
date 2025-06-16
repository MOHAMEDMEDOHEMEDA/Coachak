//
//  MockChatAPIService.swift
//  Coashak
//
//  Created by Mohamed Magdy on 15/06/2025.
//


import Foundation
@testable import Coashak

class MockChatAPIService: ChatAPIServiceProtocol {
    var shouldFail = false
    var replyText = "Mocked reply"
    var testSessionID = "mock-session-id"

    func generateTestToken() async throws -> String {
        return "mock-token"
    }

    func sendMessage(request: ChatMessageRequest) async throws -> ChatMessageResponse {
        if shouldFail {
            throw NSError(domain: "MockError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Mock failure"])
        }
        return ChatMessageResponse(reply: replyText, session_id: testSessionID)
    }

    func endSession(sessionID: String) async throws {
        // No-op for testing
    }
}
