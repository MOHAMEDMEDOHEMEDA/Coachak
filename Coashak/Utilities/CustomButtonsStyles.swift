//
//  CustomButtonsStylew.swift
//  Coashak
//
//  Created by Mohamed Magdy on 27/10/2024.
//

import SwiftUI


struct GradientButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .fontWeight(.bold)
            .frame(maxWidth: .infinity)
            .padding()
            .background(
                LinearGradient(colors: [Color.colorPurple, Color.colorPink],
                               startPoint: .leading,
                               endPoint: .trailing)
            )
            .foregroundColor(.white)
            .cornerRadius(10)
            .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 4) // Optional shadow for depth
            .opacity(configuration.isPressed ? 0.7 : 1.0) // Adds opacity when pressed
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0) // Slight scale effect when pressed
            .padding(.horizontal, 46)
            .padding(.bottom, 46)
    }
    
}
struct SecondaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .fontWeight(.bold)
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.colorPink)
            .foregroundColor(.white)
            .cornerRadius(10)
            .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 4) // Optional shadow for depth
            .opacity(configuration.isPressed ? 0.7 : 1.0) // Adds opacity when pressed
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0) // Slight scale effect when pressed
            .padding(.horizontal, 46)
            .padding(.bottom, 46)
    }
}
struct thirdButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .fontWeight(.bold)
            .frame(width: 238, height: 56, alignment: .center)
            .background(Color.colorPurple)
            .foregroundColor(.white)
            .cornerRadius(10)
            .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 4) // Optional shadow for depth
            .opacity(configuration.isPressed ? 0.7 : 1.0) // Adds opacity when pressed
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0) // Slight scale effect when pressed
            .padding(.horizontal, 46)
            .padding(.bottom, 46)
    }
}
struct DoneButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .fontWeight(.bold)
            .frame(maxWidth: .infinity)
            .padding()
        //.background(Color.colorWhiteBlue)
            .foregroundColor(.colorPurple)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.colorPurple, lineWidth: 2) // Add stroke here
            )
            .cornerRadius(10)
            .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 4) // Optional shadow for depth
            .opacity(configuration.isPressed ? 0.7 : 1.0) // Adds opacity when pressed
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0) // Slight scale effect when pressed
            .padding(.horizontal, 46)
            .padding(.bottom, 46)
    }
}

struct DisabledButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .fontWeight(.bold)
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.gray)
            .foregroundColor(.white)
            .cornerRadius(10)
            .opacity(0.6) // Optional: Dimmed effect for disabled buttons
            .padding(.horizontal, 46)
            .padding(.bottom, 46)
    }
}


