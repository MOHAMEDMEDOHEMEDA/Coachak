////
////  SignupViewModelTests.swift
////  CoashakTests
////
////  Created by Mohamed Magdy on 19/01/2025.
////
//
//import XCTest
//@testable import Coashak
//
//class SignUpViewModelTests: XCTestCase {
//    var viewModel: SignUpViewModel!
//    var networkManager: MockNetworkManager!
//
//    @MainActor override func setUp() {
//        super.setUp()
//        networkManager = MockNetworkManager()
//        viewModel = SignUpViewModel(networkManager: networkManager)
//    }
//
//    override func tearDown() {
//        viewModel = nil
//        networkManager = nil
//        super.tearDown()
//    }
//
//    func testSignUpSuccess() async {
//        // Arrange
//        networkManager.shouldReturnError = false
//        viewModel.email = "test@example.com"
//        viewModel.firstName = "John"
//        viewModel.lastName = "Doe"
//        viewModel.password = "password123"
//        viewModel.confirmPassword = "password123"
//        viewModel.role = "Client"
//
//        // Act
//        await viewModel.signUp()
//
//        // Assert
//        XCTAssertTrue(viewModel.isSuccess)
//        XCTAssertEqual(viewModel.alertMessage, "Sign up successful!")
//    }
//
//    func testSignUpFailure() async {
//        // Arrange
//        networkManager.shouldReturnError = true
//        viewModel.email = "test@example.com"
//        viewModel.firstName = "John"
//        viewModel.lastName = "Doe"
//        viewModel.password = "password123"
//        viewModel.confirmPassword = "password123"
//        viewModel.role = "Client"
//
//        // Act
//        await viewModel.signUp()
//
//        // Assert
//        XCTAssertFalse(viewModel.isSuccess)
//        XCTAssertEqual(viewModel.alertMessage, "Sign up failed due to server error.")
//    }
//
//    func testInvalidInputs() async {
//        // Arrange
//        viewModel.email = "invalid-email"
//        viewModel.password = "pass"
//        viewModel.confirmPassword = "different"
//
//        // Act
//        await viewModel.signUp()
//
//        // Assert
//        XCTAssertFalse(viewModel.isSuccess)
//        XCTAssertEqual(viewModel.alertMessage, "Invalid input. Please check your email and passwords.")
//    }
//}
//
//// Mock NetworkManager for testing
//class MockNetworkManager: NetworkManager {
//    var shouldReturnError = false
//
//    override func signUp(user: RegistrationRequest) async throws -> String {
//        if shouldReturnError {
//            throw RegistrationError.serverError("Sign up failed due to server error.")
//        } else {
//            return "Sign up successful!"
//        }
//    }
//}
////