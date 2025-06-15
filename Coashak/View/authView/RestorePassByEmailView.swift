//
//  RestorePassByEmailScreen.swift
//  Coashak
//
//  Created by Mohamed Magdy on 27/10/2024.
//


import SwiftUI

struct RestorePassByEmailView: View {
    
    @StateObject var viewModel : RestoreByEmailViewModel
    @StateObject private var sendCodeViewModel = RestorePasswordViewModel()
    
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Code Verification")
                    .font(.system(size: 30,weight: .bold,design: .default))
                    .multilineTextAlignment(.center)
                Spacer()
                Image("Code_Verification_Screen").resizable()
                    .scaledToFit()
                
                Spacer()
                
                Text(LocalizedStringKey("please enter the  6-digit number \nsent to your email")).multilineTextAlignment(.center)
                
                
                HStack(alignment: .top) {
                    Image(systemName: "number")
                        .resizable()
                        .frame(width: 24, height: 20)
                    TextField("code", text: $viewModel.code)
                        .keyboardType(.numberPad)
                        .textContentType(.flightNumber)
                }
                .padding()
                .background(Color(.systemGray6))
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray, lineWidth: 0.4)
                )
                .padding()
                
                
                Button(action: {
                    Task{
                        await sendCodeViewModel.handlePasswordRestore()
                    }
                })
                {
                    
                    Text("Resend Code")
                        .foregroundStyle(Color(.colorPurple))
                        .underline()
                    
                    
                }
                .padding()
                if #available(iOS 17.0, *) {
                    Button(action: {
                        Task{
                            await viewModel.handlePasswordVerfication()
                        }
                    }) {
                        Text("Continue")
                        
                    }
                    .buttonStyle(thirdButtonStyle())
                    .keyboardType(.numberPad)
                    .padding(.horizontal)
                    .padding(.bottom,30)
                    .onChange(of: viewModel.code){
                        if viewModel.code.count > 6 {
                            viewModel.code = String(viewModel.code.prefix(6))
                        }
                    }
                    .navigationDestination(isPresented: $viewModel.navigateCreateNewPass) {
                        CreateNewPassView(vm: CreatePasswordViewModel(email: viewModel.email))
                    }
                    .transition(.move(edge: .trailing))
                } else {
                    // Fallback on earlier versions
                }
            }
        }
        .accentColor(.colorPurple)
    }
    
}



#Preview {
    RestorePassByEmailView(viewModel: RestoreByEmailViewModel(email: "a@gmail.com"))
}
