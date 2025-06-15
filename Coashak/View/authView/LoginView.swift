//
//  LoginView.swift
//  Coashak
//
//  Created by Mohamed Magdy on 17/05/2025.
//

import SwiftUI

struct LoginView: View {
    @StateObject var logInVM = LoginViewModel()
    @EnvironmentObject var authVM: AuthViewModel   //

    @State private var navigationTarget: String? = nil

    var body: some View {
            VStack(spacing: 20) {
                
                // Email Field
                HStack(alignment: .top, spacing: 8) {
                    Image(systemName: "envelope")
                        .resizable()
                        .frame(width: 24, height: 24)
                    TextField("Email", text: $logInVM.email)
                        .keyboardType(.emailAddress)
                        .textContentType(.emailAddress)
                        .disableAutocorrection(true)
                        .autocapitalization(.none)
                }
                .formFieldStyle()
                .frame(maxWidth: 300)

                // Password Field
                HStack(alignment: .top, spacing: 8) {
                    Image(systemName: "key")
                        .resizable()
                        .frame(width: 24, height: 24)
                    Group {
                        if logInVM.passwordIsShown {
                            TextField("Password", text: $logInVM.password)
                        } else {
                            SecureField("Password", text: $logInVM.password)
                        }
                    }
                    Button(action: {
                        logInVM.passwordIsShown.toggle()
                    }) {
                        Image(systemName: logInVM.passwordIsShown ? "eye" : "eye.slash")
                            .foregroundColor(.gray)
                    }
                }
                .formFieldStyle()
                .frame(maxWidth: 300)

                // Forget Password
                NavigationLink(destination: ForgetPasswordView()) {
                    Text(LocalizedStringKey("Forget Password?"))
                        .foregroundColor(Color.colorPurple)
                }
                .frame(maxWidth: .infinity, alignment: .trailing)

                Spacer()

                // Log In Button
                Button(action: {
                    Task {
                        await logInVM.handleLogin()
                        
//                            logInVM.showAlert = true

                       
//                        authVM.loginOrSignUpToFirebaseUsingStoredCredentials()
                    }
                }) {
                    Text(LocalizedStringKey("Log In"))
                }
                .buttonStyle(SecondaryButtonStyle())
                .padding(.horizontal)
                .padding(.top, 15)
                .alert(isPresented: $logInVM.showAlert) {
                    if logInVM.isSuccess {
                        return Alert(
                            title: Text("Welcome Back! 🎉")
                                .fontWeight(.bold),
                            message: Text("You have successfully logged in."),
                            dismissButton: .default(Text("Continue")) {
                                if let role = UserDefaults.standard.string(forKey: "user_type") {
                                    print(role)
                                    navigationTarget = role
                                }
                            }
                        )
                    } else {
                        return Alert(
                            title: Text("Login Failed")
                                .fontWeight(.semibold),
                            message: Text(logInVM.alertmessage)
                                .foregroundColor(.red),
                            dismissButton: .default(Text("Try Again").foregroundColor(.colorPurple))
                        )
                    }
                }


                // Navigation logic
                NavigationLink(
                    destination: navigationDestinationView(for: navigationTarget),
                    isActive: Binding(
                        get: { navigationTarget != nil },
                        set: { if !$0 { navigationTarget = nil } }
                    )
                ) { EmptyView() }
                .hidden()
            }
            .padding()
        
//        .onAppear {
//            Task{
//                 await logInVM.handleLoginAgain()
//            }
//        }
    }

    @ViewBuilder
    func navigationDestinationView(for role: String?) -> some View {
        switch role {
        case "client":
            MainTraineeTabView()
        case "trainer":
            MainTrainerTabView()
        default:
            EmptyView()
        }
    }
}

#Preview {
    LoginView()
        .environmentObject(AuthViewModel()) // Required for Firebase auth
}
