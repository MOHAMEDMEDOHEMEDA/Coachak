//
//  LoginViewModel.swift
//  Coashak
//
//  Created by Mohamed Magdy on 16/01/2025.
//

import Foundation

@MainActor
class LoginViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var userType = ""
    @Published var isLoggedIn = false
    @Published var isSuccess = false
    @Published var alertmessage = ""
    @Published var showAlert = false
    @Published var navigationBool = false
    @Published var passwordIsShown = false
    @Published var confirmPasswordIsShown = false
    let defaults = UserDefaults.standard
    
    // Function to handle login
    func handleLogin() async {
        Task{
            do {
                // Call the login method from NetworkManager and unpack the tuple
                let (successMessage, response) = try await NetworkManager.shared.logIn(email: email, password: password)
                
                
                
                // Update state on success
                isLoggedIn = true
                showAlert = true
                isSuccess = true
                alertmessage = successMessage
                userType = response.data.user.role
                
                
            } catch {
                // Handle error and update UI state
                isLoggedIn = false
                isSuccess = false
                showAlert = true
                alertmessage = error.localizedDescription
                
            }
        }
    }
    
    // Function to handle automatic login if credentials exist
    func handleLoginAgain() async {
        guard let savedEmail = defaults.string(forKey: "email"),
              let savedPassword = defaults.string(forKey: "password") else {
            return
        }
        
        email = savedEmail
        password = savedPassword
        Task{
            
            do {
                let (successMessage, response) = try await NetworkManager.shared.logIn(email: email, password: password)
                

                isLoggedIn = true
                isSuccess = true
                alertmessage = successMessage
                userType = response.data.user.role
                showAlert = true
                
                
                
            } catch {
                isLoggedIn = false
                alertmessage = error.localizedDescription
                showAlert = true
                isSuccess = false
            }
        }
    }
    
    // Function to sign out and remove token/credentials
    func signout() {
        defaults.removeObject(forKey: "access_token")
        defaults.removeObject(forKey: "email")
        defaults.removeObject(forKey: "password")
        
        isLoggedIn = false
    }
}

