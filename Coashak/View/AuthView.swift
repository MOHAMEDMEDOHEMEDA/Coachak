//
//  AuthView.swift
//  Coashak
//
//  Created by Mohamed Magdy on 03/11/2024.
//

import SwiftUI

struct AuthView: View {
    @State private var selectedSegment = ""

    var body: some View {
        NavigationStack {
            VStack{
              
                VStack {
                    CustomSegmentedPicker(selectedSegment: $selectedSegment)
                        .padding(.top,32)
                    if selectedSegment == "Sign up" {
                        SignUpView()
                    } else {
                        LoginView()
                    }
                }
                .frame(maxWidth: .infinity,maxHeight: .infinity, alignment: .leading)
                .background(Color.white)
                .cornerRadius(70, corners: [.topRight])
                .shadow(radius: 20)
                .padding(.top,180)
                .ignoresSafeArea(.all)

            }
            .background(Color.colorLightPink)
        }
        .accentColor(.colorPurple)
    }
        
}

#Preview {
    AuthView()
}
