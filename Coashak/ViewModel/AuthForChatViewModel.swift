//
//  AuthViewModel.swift
//  Coashak
//
//  Created by Mohamed Magdy on 17/05/2025.
//

import Foundation
import FirebaseAuth
import Combine

class AuthViewModel: ObservableObject {
    @Published var user: UserForChat?   // Your own User model
    @Published var isAuthenticated = false
    @Published var errorMessage: String?

    private var handle: AuthStateDidChangeListenerHandle?

    init() {
        listenToAuthState()
    }

    private func mapFirebaseUserToUser(_ firebaseUser: FirebaseAuth.User) -> UserForChat {
        return UserForChat(
            id: firebaseUser.uid,
            displayName: firebaseUser.displayName ?? "No Name",
            email: firebaseUser.email,
            avatarUrl: firebaseUser.photoURL
        )
    }

    func listenToAuthState() {
        handle = Auth.auth().addStateDidChangeListener { [weak self] _, firebaseUser in
            if let firebaseUser = firebaseUser {
                self?.user = self?.mapFirebaseUserToUser(firebaseUser)
                self?.isAuthenticated = true
            } else {
                self?.user = nil
                self?.isAuthenticated = false
            }
        }
    }

    func signUp(email: String, password: String) {
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
            if let error = error {
                self?.errorMessage = error.localizedDescription
                return
            }
            if let firebaseUser = result?.user {
                self?.user = self?.mapFirebaseUserToUser(firebaseUser)
                self?.isAuthenticated = true
            }
        }
    }

    func signIn(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in
            if let error = error {
                self?.errorMessage = error.localizedDescription
                return
            }
            if let firebaseUser = result?.user {
                self?.user = self?.mapFirebaseUserToUser(firebaseUser)
                self?.isAuthenticated = true
            }
        }
    }

    func loginOrSignUpToFirebaseUsingStoredCredentials() {
        guard let email = UserDefaults.standard.string(forKey: "email"),
              let password = UserDefaults.standard.string(forKey: "password") else {
            print("No stored credentials found")
            return
        }

        Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in
            if let error = error as NSError?, error.code == AuthErrorCode.userNotFound.rawValue {
                // User not found, create new account
                Auth.auth().createUser(withEmail: email, password: password) { result, error in
                    if let error = error {
                        self?.errorMessage = "Firebase sign-up failed: \(error.localizedDescription)"
                        print(self?.errorMessage ?? "")
                        return
                    }

                    if let firebaseUser = result?.user {
                        self?.user = self?.mapFirebaseUserToUser(firebaseUser)
                        self?.isAuthenticated = true
                        print("Firebase account created and signed in.")
                    }
                }
            } else if let error = error {
                self?.errorMessage = "Firebase sign-in failed: \(error.localizedDescription)"
                print(self?.errorMessage ?? "")
            } else if let firebaseUser = result?.user {
                self?.user = self?.mapFirebaseUserToUser(firebaseUser)
                self?.isAuthenticated = true
                print("Signed in to Firebase successfully.")
            }
        }
    }

    func signOut() {
        do {
            try Auth.auth().signOut()
            user = nil
            isAuthenticated = false
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    deinit {
        if let handle = handle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }
}
