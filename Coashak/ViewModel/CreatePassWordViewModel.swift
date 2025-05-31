//
//  CreatePassWordViewModel.swift
//  Coashak
//
//  Created by Mohamed Magdy on 19/01/2025.
//

import Foundation


@MainActor

class CreatePasswordViewModel: ObservableObject {
    
    @Published var alertMessage = ""
    @Published var navigateToPasswordRestored = false
    @Published var newPassIsShown = false
    @Published var confirmPassIsShown = false
    @Published var isSuccess = false
    @Published var showAlert = false
    @Published var newPass = ""
    @Published var confirmNewPass = ""
    @Published var email = ""

    init(email: String) {
        self.email = email
    }

    func handleSettingNewPass() async{
        
            do {
                // Call the login method from NetworkManager and unpack the tuple
                let successMessage = try await NetworkManager.shared.setNewPassword(email: email, newPassword: newPass, confirmPassword: confirmNewPass)
                
                
                
                // Update state on success
                showAlert = true
                isSuccess = true
                navigateToPasswordRestored = true
                alertMessage = successMessage
                
                
            } catch {
                // Handle error and update UI state
                isSuccess = false
                showAlert = true
                navigateToPasswordRestored = false
                alertMessage = error.localizedDescription
                
            }
        
    }
    
}
