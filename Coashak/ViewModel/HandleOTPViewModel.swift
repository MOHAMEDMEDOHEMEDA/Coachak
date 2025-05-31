//
//  HandleOTPViewModel.swift
//  Coashak
//
//  Created by Mohamed Magdy on 16/01/2025.
//

import Foundation


@MainActor
class HandleOTPViewModel: ObservableObject {
    
    @Published var OTP = ""
    @Published var alertMessage = ""
    @Published var isSuccess = false
    @Published var showAlert = false
    @Published var email = ""
    @Published var userRole: String = ""
    @Published var navigationTarget: String? = nil



    init(email: String) {
        self.email = email
    }
    
    func handleVerifyEmail() async {
        do {
            let result = try await NetworkManager.shared.verifyByOtp(otp: OTP)
            isSuccess = true
            alertMessage = result.message
            userRole = result.role
            navigationTarget = result.role // "trainee" or "trainer"

        } catch {
            alertMessage = "Failed to verify."
            isSuccess = false
        }
        showAlert = true
    }
    
    func handleSendOtp(email: String) async {
        do {
            let successMessage = try await NetworkManager.shared.sendOtpToEmail(email: email)
            alertMessage = successMessage
            isSuccess = true
        } catch {
            alertMessage = "Failed to send OTP. Please try again."
            isSuccess = false
        }
        showAlert = true
    }
}
