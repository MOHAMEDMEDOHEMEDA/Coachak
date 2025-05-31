//
//  RestorePassWordViewModel.swift
//  Coashak
//
//  Created by Mohamed Magdy on 19/01/2025.
//


import Foundation


@MainActor

class RestorePasswordViewModel: ObservableObject {
    
    @Published var email = ""
    @Published var alertMessage = ""
    @Published var navigateToRestoreByEmail = false
    
    
    func handlePasswordRestore() async {
        do {
            let successMessage = try await NetworkManager.shared.sendCodeForPasswordReset(email: email)
            alertMessage = successMessage
            navigateToRestoreByEmail = true
        } catch {
            alertMessage = "Failed to send code. Please try again."
        }
    }
    
}








