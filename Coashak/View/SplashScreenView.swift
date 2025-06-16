//
//  SplashScreenView.swift
//  Coashak
//
//  Created by Mohamed Magdy on 15/06/2025.
//


import SwiftUI

struct SplashScreenView: View {
    @State private var isActive = false
    @State private var logoScale: CGFloat = 0.6
    @State private var logoOpacity: Double = 0.0

    var body: some View {
        if isActive {
            // Navigate to your actual home view
            OnBoardingView()
        } else {
            VStack {
                Image("splash_screen")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                    .scaleEffect(logoScale)
                    .opacity(logoOpacity)
                    .animation(.easeOut(duration: 1.2), value: logoScale)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.white)
            .ignoresSafeArea()
            .onAppear {
                // Start animations
                logoScale = 1.0
                logoOpacity = 1.0
                
                // Navigate after delay
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                    withAnimation {
                        isActive = true
                    }
                }
            }
        }
    }
}
