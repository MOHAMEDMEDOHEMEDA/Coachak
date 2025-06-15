//
//  PasswordRestoredView.swift
//  Coashak
//
//  Created by Mohamed Magdy on 27/10/2024.
//

import SwiftUI

struct PasswordRestoredScreen: View {
    var body: some View {
        VStack {
            Text("Password Restored")
                .font(.system(size: 30,weight: .bold,design: .default))
            
            
            Spacer()
            
            
            Image("Password Restored Screen").resizable()
                .scaledToFit()
            
            Spacer()
            
            
            
            Button(action: {
                // Handle log-in action
            }) {
                Text("Continue")
     
            }
            .buttonStyle(GradientButtonStyle())

            .padding(.horizontal)
            .padding(.bottom,30)
        }
    }
}

#Preview {
    PasswordRestoredScreen()
}

