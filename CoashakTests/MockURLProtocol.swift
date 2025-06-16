//
//  MockURLProtocol.swift
//  Coashak
//
//  Created by Mohamed Magdy on 15/06/2025.
//


import XCTest
@testable import Coashak

// MARK: - Mock URL Protocol
class MockURLProtocol: URLProtocol {
    static var testResponseData: Data?
    static var testResponse: HTTPURLResponse?
    static var testError: Error?

    override class func canInit(with request: URLRequest) -> Bool { true }
    override class func canonicalRequest(for request: URLRequest) -> URLRequest { request }

    override func startLoading() {
        if let error = Self.testError {
            self.client?.urlProtocol(self, didFailWithError: error)
        } else {
            if let response = Self.testResponse {
                self.client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            }
            if let data = Self.testResponseData {
                self.client?.urlProtocol(self, didLoad: data)
            }
            self.client?.urlProtocolDidFinishLoading(self)
        }
    }

    override func stopLoading() {}
}

// MARK: - Unit Test Class
final class SubscriptionClientViewModelTests: XCTestCase {

    var viewModel: SubscriptionClientViewModel!

    override func setUp() {
        super.setUp()
        
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        let mockSession = URLSession(configuration: config)

        viewModel = SubscriptionClientViewModel(session: mockSession)
    }


    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }

//    func testSubscribeToPlanSuccess() {
//        // Given
//        let expectation = self.expectation(description: "Subscription request succeeds")
//        let mockMessage = "Subscription successful!"
//        let mockResponseJSON = """
//        {
//            "message": "\(mockMessage)",
//            "subscription": {
//                "id": "sub123",
//                "plan": "plan001"
//            }
//        }
//        """
//
//        MockURLProtocol.testResponseData = mockResponseJSON.data(using: .utf8)
//        MockURLProtocol.testResponse = HTTPURLResponse(
//            url: URL(string: "https://coachak-backendend.onrender.com/api/v1/subscriptions")!,
//            statusCode: 200,
//            httpVersion: nil,
//            headerFields: nil
//        )
//        MockURLProtocol.testError = nil
//
//        // Simulate token in UserDefaults
//        UserDefaults.standard.setValue("fake_token", forKey: "access_token")
//
//        // When
//        viewModel.subscribeToPlan(planId: "plan001") { result in
//            // Then
//            switch result {
//            case .success(let message):
//                XCTAssertEqual(message, mockMessage)
//                XCTAssertEqual(self.viewModel.subscription?.plan, "plan001")
//            case .failure(let error):
//                XCTFail("Expected success, got failure: \(error.localizedDescription)")
//            }
//            expectation.fulfill()
//        }
//
//        wait(for: [expectation], timeout: 2.0)
//    }

    func testSubscribeToPlanFailsWithNoToken() {
        // Given
        let expectation = self.expectation(description: "Subscription fails due to missing token")
        UserDefaults.standard.removeObject(forKey: "access_token")

        // When
        viewModel.subscribeToPlan(planId: "plan001") { result in
            // Then
            switch result {
            case .success:
                XCTFail("Expected failure due to missing token, but got success")
            case .failure(let error):
                XCTAssertEqual(error.localizedDescription, "Token missing")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 2.0)
    }
}
