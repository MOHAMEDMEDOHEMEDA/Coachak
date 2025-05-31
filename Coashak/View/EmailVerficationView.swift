//
//  EmailVerficationView.swift
//  Coashak
//
//  Created by Mohamed Magdy on 27/10/2024.
//

import SwiftUI

struct EmailVerficationView: View {
    @StateObject var vm: HandleOTPViewModel
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Confirm Your Email")
                    .font(.system(size: 30, weight: .bold, design: .default))
                Text("Please enter the code that was sent to")
                Text(vm.email)
                    .multilineTextAlignment(.center)
                Spacer()
                Image("Email_Verification_Screen")
                    .resizable()
                    .scaledToFit()
                Spacer()
                
                HStack(alignment: .top) {
                    Image(systemName: "lock.circle.dotted")
                        .resizable()
                        .frame(width: 24, height: 24)
                    TextField("Enter OTP", text: $vm.OTP)

                }
                .formFieldStyle()
                
                
                Button(action: {
                    Task{
                        await vm.handleSendOtp(email:vm.email )
                    }
                    
                }) {
                    Text("Resend Code")
                        .foregroundColor(.colorPink)
                        .underline()
                }
                .padding()
                
                Button(action: {
                    Task {
                        await vm.handleVerifyEmail()
                    }
                   
                }) {
                    Text("Verify")
                }
                .buttonStyle(SecondaryButtonStyle())
                .padding(.horizontal)
                .padding(.bottom, 30)
                .alert(isPresented: $vm.showAlert) {
                    Alert(
                        title: Text(vm.isSuccess ? "Success" : "Failed"),
                        message: Text(vm.alertMessage),
                        dismissButton: .default(Text("OK"))
                    )
                }
                
                .navigationDestination(isPresented: $vm.isSuccess) {
                    EmailVerifiedView()        .environmentObject(vm)

                }
                .transition(.move(edge: .trailing))
            }
        }
    }
}

#Preview {
    EmailVerficationView(vm: HandleOTPViewModel(email: "a@gmail.com"))
}
