//
//  ChatViewModelTests.swift
//  Coashak
//
//  Created by Mohamed Magdy on 15/06/2025.
//


import XCTest
@testable import Coashak

final class ChatViewModelTests: XCTestCase {
    var viewModel: ChatViewModel!
    var mockService: MockChatAPIService!

    override func setUp() {
        super.setUp()
        mockService = MockChatAPIService()
        ChatAPIService.shared = mockService
        viewModel = ChatViewModel()
    }

    override func tearDown() {
        viewModel = nil
        mockService = nil
        super.tearDown()
    }

    func testSendMessage_AppendsUserMessage() async {
        await viewModel.sendMessage("Hello")
        XCTAssertEqual(viewModel.messages.first?.text, "Hello")
        XCTAssertTrue(viewModel.messages.first?.isUser == true)
    }

    func testSendMessage_AppendsResponseMessage() async {
        await viewModel.sendMessage("Hello")
        XCTAssertEqual(viewModel.messages.last?.text, "Mocked reply")
        XCTAssertFalse(viewModel.messages.last?.isUser ?? true)
    }

    func testSendMessage_WhenFailure_AppendsError() async {
        mockService.shouldFail = true
        await viewModel.sendMessage("Trigger Error")
        XCTAssertTrue(viewModel.messages.last?.text.contains("Error") ?? false)
    }

    func testEndChat_ClearsSessionAndMessages() async {
        viewModel.sessionID = "some-session"
        viewModel.messages = [ChatMessage(text: "User message", isUser: true)]

        await viewModel.endChat()

        XCTAssertNil(viewModel.sessionID)
        XCTAssertTrue(viewModel.messages.isEmpty)
    }
}
