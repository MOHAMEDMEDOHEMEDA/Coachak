//
//  SignupViewModel.swift
//  Coashak
//
//  Created by Mohamed Magdy on 16/12/2024.
//

import Foundation
import Combine

@MainActor
class SignUpViewModel: ObservableObject {
    // MARK: - Input Fields
    @Published var email: String = ""
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var phoneNumber: String = ""
    @Published var dateOfBirth: Date = Date()
    @Published var gender: String = ""
    @Published var role: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""

    // MARK: - UI States
    @Published var passwordIsShown = false
    @Published var confirmPasswordIsShown = false
    @Published var showAlert = false
    @Published var isSuccess = false
    @Published var alertMessage = ""
    @Published var navigateToConfirmationEmail = false
    @Published var isLoading = false

    private var cancellables = Set<AnyCancellable>()

    // MARK: - Sign Up Function
    func signUp() async {
        alertMessage = ""
        isSuccess = false
        isLoading = true

        let registrationRequest = RegistrationRequest(
            email: email,
            firstName: firstName,
            lastName: lastName,
            phoneNumber: phoneNumber,
            dateOfBirth: dateOfBirth,
            role: role,
            password: password,
            confirmPassword: confirmPassword
        )

        do {
            let response = try await NetworkManager.shared.signUp(user: registrationRequest)

            // MARK: - Save tokens and user data
            UserDefaults.standard.set(response.data.accessToken, forKey: "access_token")
            UserDefaults.standard.set(response.data.refreshToken, forKey: "refresh_token")
            UserDefaults.standard.set(response.data.user.email, forKey: "user_email")
            UserDefaults.standard.set(response.data.user.role, forKey: "user_role")

            alertMessage = response.message
            isSuccess = true
            showAlert = true
            navigateToConfirmationEmail = true

            // Optional: Clear form fields
            clearForm()

        } catch let error as RegistrationError {
            alertMessage = error.localizedDescription
            isSuccess = false
            showAlert = true
        } catch {
            alertMessage = "An unexpected error occurred."
            isSuccess = false
            showAlert = true
        }

        isLoading = false
    }

    // MARK: - Utility
    private func clearForm() {
        email = ""
        firstName = ""
        lastName = ""
        phoneNumber = ""
        password = ""
        confirmPassword = ""
        role = ""
        gender = ""
        dateOfBirth = Date()
    }
}
