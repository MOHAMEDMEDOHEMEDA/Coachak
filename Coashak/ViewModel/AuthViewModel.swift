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
    @Published var user: User?
    @Published var isAuthenticated = false
    @Published var errorMessage: String?

    private var handle: AuthStateDidChangeListenerHandle?

    init() {
        listenToAuthState()
    }

    private func mapFirebaseUserToUser(_ firebaseUser: FirebaseAuth.User) -> User {
        return User(
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

    func signOut() {
        do {
            try Auth.auth().signOut()
            user = nil
            isAuthenticated = false
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    // Update user profile information
    func updateProfile(displayName: String? = nil, photoURL: URL? = nil) {
        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
        
        if let displayName = displayName {
            changeRequest?.displayName = displayName
        }
        
        if let photoURL = photoURL {
            changeRequest?.photoURL = photoURL
        }
        
        changeRequest?.commitChanges { [weak self] error in
            if let error = error {
                self?.errorMessage = error.localizedDescription
                return
            }
            
            // Update local user object
            if let firebaseUser = Auth.auth().currentUser {
                self?.user = self?.mapFirebaseUserToUser(firebaseUser)
            }
        }
    }

    deinit {
        if let handle = handle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }
}
