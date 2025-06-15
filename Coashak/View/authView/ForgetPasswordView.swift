//
//  ForgetPasswordView.swift
//  Coashak
//
//  Created by Mohamed Magdy on 27/10/2024.
//

import SwiftUI

struct ForgetPasswordView: View {
  @StateObject var vm = RestorePasswordViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Forget Password")
                    .font(.system(size: 30,weight: .bold,design: .default))
                Spacer()
                Image("Forget Password Screen").resizable()
                    .scaledToFit()
                
                Spacer()
                
                Text(LocalizedStringKey("please enter you email adress to send verfication code")).multilineTextAlignment(.center)
                    .padding(.bottom,40)

                
                HStack(alignment: .top) {
                    Image(systemName: "envelope")
                        .resizable()
                        .frame(width: 24, height: 20)
                    TextField("Email", text: $vm.email)
                        .keyboardType(.emailAddress)
                        .textContentType(.emailAddress)
                        .disableAutocorrection(true)
                        .autocapitalization(.none)
                }
                .formFieldStyle()
                .padding(.bottom,40)
                
                Button(action: {
                    Task{
                       await vm.handlePasswordRestore()
                    }
                }) {
                    Text("Continue")

                }
                .buttonStyle(thirdButtonStyle())
                .padding(.horizontal)
                .padding(.bottom,30)
                .navigationDestination(isPresented: $vm.navigateToRestoreByEmail) {
                    RestorePassByEmailView(viewModel: RestoreByEmailViewModel(email: vm.email))
                }
    .transition(.move(edge: .trailing))
            }
        }
        .accentColor(.colorPurple)

    }
    // function to check email is valid
    func isValidEmailAddr(strToValidate: String) -> Bool {
        let emailValidationRegex = "^[\\p{L}0-9!#$%&'*+\\/=?^_`{|}~-][\\p{L}0-9.!#$%&'*+\\/=?^_`{|}~-]{0,63}@[\\p{L}0-9-]+(?:\\.[\\p{L}0-9-]{2,7})*$"
        let emailValidationPredicate = NSPredicate(format: "SELF MATCHES %@", emailValidationRegex)
        return emailValidationPredicate.evaluate(with: strToValidate)
    }
}

#Preview {
    ForgetPasswordView()
}

