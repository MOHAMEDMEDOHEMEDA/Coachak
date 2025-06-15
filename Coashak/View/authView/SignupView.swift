//
//  SignUpView.swift
//  Coashak
//
//  Created by Mohamed Magdy on 27/10/2024.
//

//
//  SignUpView.swift
//  Coashak
//
//  Created by Mohamed Magdy on 27/10/2024.
//

import SwiftUI

struct SignUpView: View {
    
    @StateObject private var viewModel = SignUpViewModel()
    
    @EnvironmentObject var authVM: AuthViewModel
    
    var body: some View {
            ScrollView {
                VStack(alignment: .center, spacing: 16) {
                    
                    // First Name
                    Section(header: Text("First Name")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading,16)
                    ) {
                        HStack(alignment: .top, spacing: 8) {
                            Image(systemName: "person")
                                .resizable()
                                .frame(width: 24, height: 24)
                            TextField("First Name", text: $viewModel.firstName)
                                .autocorrectionDisabled()
                        }
                        .formFieldStyle()
                        .frame(maxWidth: 300) // Limit width and center the field
                    }
                    
                    // Last Name
                    Section(header: Text("Last Name")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading,16)
                    ) {
                        HStack(alignment: .top, spacing: 8) {
                            Image(systemName: "person")
                                .resizable()
                                .frame(width: 24, height: 24)
                            TextField("Last Name", text: $viewModel.lastName)
                                .autocorrectionDisabled()
                        }
                        .formFieldStyle()
                        .frame(maxWidth: 300)
                    }
                    
                    // Email
                    Section(header: Text("Email")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading,16)
                    ) {
                        HStack(alignment: .top, spacing: 8) {
                            Image(systemName: "envelope")
                                .resizable()
                                .frame(width: 24, height: 24)
                            TextField("Email", text: $viewModel.email)
                                .keyboardType(.emailAddress)
                                .textContentType(.emailAddress)
                                .disableAutocorrection(true)
                                .autocapitalization(.none)
                        }
                        .formFieldStyle()
                        .frame(maxWidth: 300)
                    }
                    
                    // Password
                    Section(header: Text("Password")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading,16)
                    ) {
                        HStack(alignment: .top, spacing: 8) {
                            Image(systemName: "key")
                                .resizable()
                                .frame(width: 24, height: 24)
                            Group {
                                if viewModel.passwordIsShown {
                                    TextField("Password", text: $viewModel.password)
                                } else {
                                    SecureField("Password", text: $viewModel.password)
                                }
                            }
                            Button(action: {
                                viewModel.passwordIsShown.toggle()
                            }) {
                                Image(systemName: viewModel.passwordIsShown ? "eye" : "eye.slash")
                                    .foregroundColor(.gray)
                            }
                        }
                        .formFieldStyle()
                        .frame(maxWidth: 300)
                    }
                    
                    // Confirm Password
                    Section(header: Text("Confirm Password")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading,16)
                    ) {
                        HStack(alignment: .top, spacing: 8) {
                            Image(systemName: "key")
                                .resizable()
                                .frame(width: 24, height: 24)
                            Group {
                                if viewModel.confirmPasswordIsShown {
                                    TextField("Confirm Password", text: $viewModel.confirmPassword)
                                } else {
                                    SecureField("Confirm Password", text: $viewModel.confirmPassword)
                                }
                            }
                            Button(action: {
                                viewModel.confirmPasswordIsShown.toggle()
                            }) {
                                Image(systemName: viewModel.confirmPasswordIsShown ? "eye" : "eye.slash")
                                    .foregroundColor(.gray)
                            }
                        }
                        .formFieldStyle()
                        .frame(maxWidth: 300)
                    }
                    
                    // Gender
                    Section(header: Text("Gender")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading,16)                    ) {
                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    Image(systemName: viewModel.gender == "male" ? "largecircle.fill.circle" : "circle")
                                    Text("Male")
                                }
                                .onTapGesture { viewModel.gender = "male" }
                                
                                HStack {
                                    Image(systemName: viewModel.gender == "female" ? "largecircle.fill.circle" : "circle")
                                    Text("Female")
                                }
                                .onTapGesture { viewModel.gender = "female" }
                            }
                            .frame(maxWidth: 300, alignment: .leading)
                        }
                    
                    // User Type
                    Section(header: Text("Choose user type")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading,16)                    ) {
                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    Image(systemName: viewModel.role == "Client" ? "largecircle.fill.circle" : "circle")
                                    Text("Client")
                                }
                                .onTapGesture { viewModel.role = "Client" }
                                
                                HStack {
                                    Image(systemName: viewModel.role == "Trainer" ? "largecircle.fill.circle" : "circle")
                                    Text("Trainer")
                                }
                                .onTapGesture { viewModel.role = "Trainer" }
                            }
                            .frame(maxWidth: 300, alignment: .leading)
                        }
                    
                    // Phone Number
                    Section(header: Text("Phone Number")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading,16)                    ) {
                            HStack(alignment: .top, spacing: 8) {
                                Image(systemName: "phone")
                                    .resizable()
                                    .frame(width: 24, height: 24)
                                TextField("Phone Number", text: $viewModel.phoneNumber)
                                    .textContentType(.telephoneNumber)
                            }
                            .formFieldStyle()
                            .frame(maxWidth: 300)
                        }
                    
                    // Date of Birth
                    Section(header: Text("Date of Birth")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading,16)                    ) {
                            DatePicker("Date of Birth", selection: $viewModel.dateOfBirth, displayedComponents: .date)
                                .datePickerStyle(.compact)
                                .formFieldStyle()
                                .frame(maxWidth: 300)
                                .padding(.bottom, 16)
                        }
                    
                    // Bottom Button
                    Button(action: {
                        Task{
                            await viewModel.signUp()
                        }
                        
                    
                    }) {
                        Text("Create account")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(GradientButtonStyle())
                    .frame(maxWidth: 300)
                    .alert(isPresented: $viewModel.showAlert) {
                        if viewModel.isSuccess {
                            return Alert(
                                title: Text("Account Created 🎉")
                                    .fontWeight(.bold),
                                message: Text("Please verify your email to complete registration."),
                                dismissButton: .default(Text("Verify Now")) {
                                    viewModel.navigateToConfirmationEmail = true
                                }
                            )
                        } else {
                            return Alert(
                                title: Text("Signup Failed")
                                    .fontWeight(.semibold),
                                message: Text(viewModel.alertMessage)
                                    .foregroundColor(.red),
                                dismissButton: .default(Text("Try Again").foregroundColor(.colorPurple))
                            )
                        }
                    }
                    .navigationDestination(isPresented: $viewModel.navigateToConfirmationEmail) {
                        EmailVerficationView(vm: HandleOTPViewModel(email: viewModel.email ))
                    }
                    .transition(.move(edge: .trailing))
                    
                    // Divider with "Signup with"
                    HStack {
                        Rectangle()
                            .frame(height: 1)
                            .foregroundColor(.gray)
                        Text("Signup with")
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                        Rectangle()
                            .frame(height: 1)
                            .foregroundColor(.gray)
                    }
                    .padding(.vertical, 20)
                    .frame(maxWidth: 300)
                    
                    // Google and Facebook buttons
                    HStack(spacing: 20) {
                        Button(action: {
                            // Google login action
                        }) {
                            Image("images") // Replace with Google logo image
                                .resizable()
                                .frame(width: 24, height: 24)
                        }
                        
                        Button(action: {
                            // Facebook login action
                        }) {
                            Image("15466130") // Replace with Facebook logo image
                                .resizable()
                                .frame(width: 24, height: 24)
                        }
                    }
                    .frame(maxWidth: 300)
                    .padding(.top, 16)
                }
                .padding()
                .frame(maxWidth: .infinity)
            }
            .accentColor(.colorPurple)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
            .environmentObject(AuthViewModel())
    }
}
