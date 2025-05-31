//
//  OnBoardingView.swift
//  Coashak
//
//  Created by Mohamed Magdy on 27/10/2024.
//

import SwiftUI

struct OnBoardingView: View {
    
    @State private var currentTab = 0
   // @State private var showTraineeTrainerPopupView = false
    @State private var showAuthView = false

    var body: some View {
        NavigationStack {
            ZStack {
                VStack(alignment: .center, spacing: 0) {
                    
                    // TabView for Onboarding Pages at the top
                    TabView(selection: $currentTab) {
                        OnBoardingPage(
                            backimageName: "back_1",
                            imageName: "On-boarding 1",
                            title: "Welcome to our app!",
                            subtitle: "",
                            currentTab: $currentTab
                        )
                        .tag(0)
                        
                        OnBoardingPage(
                            backimageName: "back_2",
                            imageName: "On-boarding 2",
                            title: "We Hope You To Be Fit.",
                            subtitle: "",
                            currentTab: $currentTab
                        )
                        .tag(1)
                        
                        OnBoardingPage(
                            backimageName: "back_3",
                            imageName: "On-boarding 3",
                            title: "Let's get you set up.",
                            subtitle: "",
                            currentTab: $currentTab
                        )
                        .tag(2)
                    }
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never)) // Disable default indicator
                    .padding(.top, 110) // Adjust top padding to give more room
                    

                    // Indicator (HStack)
                    HStack(spacing: 8) {
                        ForEach(0..<3) { index in
                            if index == currentTab {
                                Capsule() // Use Capsule to create the pill shape
                                    .fill(Color.colorPurple)
                                    .frame(width: 24, height: 8)
                                    .animation(.easeInOut(duration: 0.2), value: currentTab)
                            } else {
                                Circle()
                                    .fill(Color.colorCapsule.opacity(0.3))
                                    .frame(width: 8, height: 8)
                                    .animation(.easeInOut(duration: 0.2), value: currentTab)
                            }
                        }
                    }
                    .padding(.top,28)
                    .padding(.bottom,132)
                    Spacer() // Push the button towards the bottom

                    // Navigation Button
                    Button(action: {
                        if currentTab < 2 {
                            currentTab += 1
                        } else {
                            showAuthView = true
                        }
                    }) {
                        Text(currentTab < 2 ? "Continue" : "Get Started")
                    }
                    .buttonStyle(GradientButtonStyle()) // Plain button for custom styling
                    .transition(.move(edge: .trailing))
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .ignoresSafeArea(.all)
                .background(Color.white.edgesIgnoringSafeArea(.all)) // Full screen background
                
                // Custom Popup Window
//                if showAuthView {
//                    Color.black.opacity(0.4)
//                        .edgesIgnoringSafeArea(.all)
//                        .onTapGesture {
//                            showAuthView = false // Dismiss the popup when tapping outside
//                        }
//
////                    CustomPopUPWindow(title: "please choose")
////                        .frame(width: 300, height: 150) // Adjust the size of the popup
////                        .background(Color.white)
////                        .cornerRadius(12)
////                        .shadow(radius: 10)
////                        .transition(.scale)
////                        .zIndex(1)
//                }
            }
            .navigationDestination(isPresented: $showAuthView) {
                AuthView()
            }
        }
        .accentColor(.colorPurple)
    }
}

#Preview {
    OnBoardingView()
}
