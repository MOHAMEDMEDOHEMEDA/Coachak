//
//  MainTabView.swift
//  Coashak
//
//  Created by Mohamed Magdy on 24/04/2025.
//


//import SwiftUI
//
//struct CustomTabView: View {
//    @State private var selectedTab = 1
//    
//    var body: some View {
//        ZStack {
//            // Tab content
//            Group {
//                switch selectedTab {
//                case 0: HomePageTraineeView()
//                case 1: MealPlanTraineeView()
//                case 2: TrainingPlanView()
//                case 3: TraineeProfileView()
//                default: HomePageTraineeView()
//                    
//                }
//            }
//            .edgesIgnoringSafeArea(.all)
//
//            VStack {
//                Spacer()
//                ZStack {
//                    // Custom background bar
//                    HStack {
//                        Spacer()
//                        tabItem(icon: "house.fill", index: 0)
//                        Spacer()
//                        tabItem(icon: "dumbbell.fill", index: 1)
//                        Spacer()
//                        tabItem(icon: "calendar.badge.plus", index: 2)
//                        Spacer()
//                        tabItem(icon: "person.2", index: 2)
//                        Spacer()
//                    }
//                    .padding(.horizontal)
//                    .padding(.top, 10)
//                    .frame(height: 60)
//                    .background(Color.purple)
//                    .cornerRadius(20)
//                    .shadow(radius: 4)
//                    .padding(.horizontal)
//
//                    // Floating profile button
//                    Button(action: {
//                        selectedTab = 3
//                    }) {
//                        Image(systemName: "person.crop.square")
//                            .resizable()
//                            .scaledToFit()
//                            .frame(width: 24, height: 24)
//                            .padding()
//                            .background(Color.purple.opacity(0.8))
//                            .clipShape(Circle())
//                            .overlay(Circle().stroke(Color.white, lineWidth: 2))
//                    }
//                    .offset(y: -30)
//                }
//            }
//        }
//    }
//
//    // Reusable tab item view
//    func tabItem(icon: String, index: Int) -> some View {
//        Button(action: {
//            selectedTab = index
//        }) {
//            Image(systemName: icon)
//                .resizable()
//                .scaledToFit()
//                .frame(width: 24, height: 24)
//                .foregroundColor(.white)
//        }
//    }
//}
