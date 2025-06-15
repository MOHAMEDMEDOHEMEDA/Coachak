//
//  LoginView 2.swift
//  Coashak
//
//  Created by Mohamed Magdy on 17/05/2025.
//
import SwiftUI

struct LoginViewForChat: View {
    @EnvironmentObject var authVM: AuthViewModel

    @State private var email = ""
    @State private var password = ""

    var body: some View {
        VStack(spacing: 20) {
            TextField("Email", text: $email)
                .textContentType(.emailAddress)
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8)

            SecureField("Password", text: $password)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8)

            if let errorMessage = authVM.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .font(.caption)
            }

            Button("Sign In") {
                authVM.signIn(email: email, password: password)
            }
            .buttonStyle(.borderedProminent)
            .disabled(email.isEmpty || password.isEmpty)

            Button("Create Account") {
                authVM.signUp(email: email, password: password)
            }
            .buttonStyle(.bordered)
            .disabled(email.isEmpty || password.isEmpty)
        }
        .padding()
    }
}
