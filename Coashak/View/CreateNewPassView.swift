//
//  CreateNewPassView.swift
//  Coashak
//
//  Created by Mohamed Magdy on 27/10/2024.
//

import SwiftUI

struct CreateNewPassView: View {
    @StateObject var vm: CreatePasswordViewModel
    var body: some View {
        NavigationStack {
            VStack {
                Text("Create New Password")
                    .font(.system(size: 30,weight: .bold,design: .default))
                Spacer()
                Image("Create New Password Screen").resizable()
                    .scaledToFit()
                
                Spacer()
                
                Text(LocalizedStringKey("please enter your new password ")).multilineTextAlignment(.center)
                    .padding(.bottom,4)

                // MARK: - new password text fields
                HStack(alignment: .top) {
                    Image(systemName: "lock")
                        .resizable()
                        .frame(width: 24, height: 20)
                    Group {
                        if vm.newPassIsShown {
                            TextField("Password", text: $vm.newPass)
                        } else {
                            SecureField("Password", text: $vm.newPass)
                        }
                    }
                    Button(action: {
                        vm.newPassIsShown.toggle()
                    }) {
                        Image(systemName: vm.newPassIsShown ? "eye" : "eye.slash")
                            .foregroundColor(.gray)
                    }
                }
                .formFieldStyle()
                
                // Confirm Password
                HStack(alignment: .top) {
                    Image(systemName: "lock")
                        .resizable()
                        .frame(width: 24, height: 20)
                    Group {
                        if vm.confirmPassIsShown {
                            TextField("Confirm Password", text: $vm.confirmNewPass)
                        } else {
                            SecureField("Confirm Password", text: $vm.confirmNewPass)
                        }
                    }
                    Button(action: {
                        vm.confirmPassIsShown.toggle()
                    }) {
                        Image(systemName: vm.confirmPassIsShown ? "eye" : "eye.slash")
                            .foregroundColor(.gray)
                    }
                }
                .formFieldStyle()
                .padding(.bottom,30)
                
                Button(action: {
                    Task{
                        await vm.handleSettingNewPass()
                    }
                }) {
                    Text("Save")

                }
                .buttonStyle(thirdButtonStyle())
                .padding(.horizontal)
                .padding(.bottom,30)
                .alert(isPresented: $vm.showAlert) {
                    if vm.isSuccess {
                        return Alert(
                            
                            title: Text("Success"),
                            message: Text(vm.alertMessage),
                            dismissButton: .default(Text("Ok"))
                        )
                    } else {
                        return Alert(
                            title: Text("Failed"),
                            message: Text(vm.alertMessage),
                            dismissButton: .default(Text("OK"))
                        )
                    }
                }
                .navigationDestination(isPresented: $vm.navigateToPasswordRestored) {
                    PasswordRestoredScreen()
                }
    .transition(.move(edge: .trailing))
            }
        }
        .accentColor(.colorPurple)
        .onAppear {
                 // Ensure email is set in the ViewModel when the view appears
            print("Email: \(vm.email)")
             }
    }
   
}

#Preview {
    CreateNewPassView(vm: CreatePasswordViewModel(email: "a@gmail.com"))
}
