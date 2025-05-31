//
//  LoginView.swift
//  Coashak
//
//  Created by Mohamed Magdy on 17/05/2025.
//
import SwiftUI

struct LoginView: View {
    @StateObject var logInVM = LoginViewModel()
    
    @State private var navigationTarget: String? = nil
    @State private var email = ""
    @State private var password = ""
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                
                
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
                .transition(.move(edge: .trailing))
                .frame(maxWidth: .infinity, alignment: .trailing)
                
                Spacer()
                
                // Log In Button
                Button(action: {
                    Task {
                        await logInVM.handleLogin()
                        
                        DispatchQueue.main.async {
                            logInVM.showAlert = true
                        }                    }
                }) {
                    Text(LocalizedStringKey("Log In"))
                }
                .buttonStyle(SecondaryButtonStyle())
                .padding(.horizontal)
                .padding(.top, 15)
                .alert(isPresented: $logInVM.showAlert) {
                    if logInVM.isSuccess {
                        return Alert(
                            title: Text("Success"),
                            message: Text(logInVM.alertmessage),
                            dismissButton: .default(Text("OK")) {
                                
                                if let role = UserDefaults.standard.string(forKey: "user_type") {
                                    print(role)
                                    navigationTarget = role
                                }
                            }
                        )
                    } else {
                        return Alert(
                            title: Text("Failed"),
                            message: Text(logInVM.alertmessage),
                            dismissButton: .default(Text("OK"))
                        )
                    }
                }
                
            }
            .padding()
            NavigationLink(
                destination: navigationDestinationView(for: navigationTarget),
                isActive: Binding(
                    get: { navigationTarget != nil },
                    set: { if !$0 { navigationTarget = nil } }
                )
            ) { EmptyView() }
                .hidden()
            
        }
    }
    @ViewBuilder
    func navigationDestinationView(for role: String?) -> some View {
        switch role {
        case "Client":
            MainTraineeTabView()
        case "trainer":
            HomePageForTrainerView()
        default:
            EmptyView()
        }
    }
}
#Preview{
    LoginView()
}
