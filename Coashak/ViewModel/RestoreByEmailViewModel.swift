//
//  RestoreByEmailViewModel.swift
//  Coashak
//
//  Created by Mohamed Magdy on 19/01/2025.
//

import Foundation
@MainActor

class RestoreByEmailViewModel: ObservableObject {
    
    @Published var code = ""
    @Published var email = ""
    @Published var alertMessage = ""
    @Published var navigateCreateNewPass = false

    init(email: String) {
        self.email = email
    }
    
    func handlePasswordVerfication() async {
        do {
            let successMessage = try await NetworkManager.shared.passwordVerificationCode(code: code)
            alertMessage = successMessage
            navigateCreateNewPass = true
        } catch {
            alertMessage = "Failed to send code. Please try again."
        }
    }
    
}
