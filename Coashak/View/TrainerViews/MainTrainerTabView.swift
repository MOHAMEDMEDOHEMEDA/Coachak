//
//  MainTrainerTabView.swift
//  Coashak
//
//  Created by Mohamed Magdy on 10/06/2025.
//

import SwiftUI

struct MainTrainerTabView: View {
    @State private var selectedTab = 0
    @State private var tabPositions: [CGFloat] = Array(repeating: 0, count: 4)
    @Namespace private var animation
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                Color.white
                    .ignoresSafeArea()
                
                // Tab content
                Group {
                    switch selectedTab {
                    case 0: HomePageForTrainerView()
                    case 1: YourClientsView()
                    case 2: TrainerSubscriptionPlansView()
                    case 3:TrainerProfileView()
                    default: HomePageTraineeView()
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                VStack {
                    Spacer()
                    
                    ZStack(alignment: .bottom) {
                        // Animated background curve
                        if let curveX = tabPositions[safe: selectedTab] {
                            CustomCurveTabBarShape(curveX: curveX)
                                .fill(Color.colorPurple)
                                .frame(height: 90)
                                .shadow(radius: 5)
                                .animation(.easeInOut, value: selectedTab)
                        }
                        
                        // Tab bar icons
                        HStack() {
                            tabItem(source: .system, imageName: "house.fill", index: 0)
                            tabItem(source: .system, imageName: "person.3.fill", index: 1)
                            tabItem(source: .local, imageName: "nutrition_plan", index: 2)
                            tabItem(source: .system, imageName: "person.crop.circle", index: 3)
                        }
                        .frame(height: 70)
                        .background(
                            GeometryReader { geo in
                                Color.clear
                                    .onAppear {
                                        for i in 0..<4 {
                                            let buttonWidth = geo.size.width / 4
                                            tabPositions[i] = buttonWidth * CGFloat(i) + buttonWidth / 2
                                            // Account for horizontal padding
                                        }
                                    }
                            }
                        )
                    }
                }
            }
            .ignoresSafeArea(.all, edges: .bottom)
        }
    }
    enum Source {
        case local
        case system
    }
    
    // MARK: - Tab Item
    func tabItem(source: Source, imageName: String, index: Int) -> some View {
        Button(action: {
            withAnimation(.easeInOut) {
                selectedTab = index
            }
        }) {
            VStack {
                getImageView(source: source, imageName: imageName, index: index)
            }
            .frame(maxWidth: .infinity)
            .padding(.bottom, 30)
        }
    }

    // MARK: - Image View Builder
    @ViewBuilder
    func getImageView(source: Source, imageName: String, index: Int) -> some View {
        if source == .system {
            Image(systemName: imageName)
                .resizable()
                .scaledToFit()
                .frame(width: selectedTab == index ? 30 : 24,
                       height: selectedTab == index ? 30 : 24)
                .foregroundColor(.white)
                .padding(selectedTab == index ? 14 : 10)
                .background(
                    Circle()
                        .fill(Color.colorPink.opacity(selectedTab == index ? 1 : 0))
                )
                .scaleEffect(selectedTab == index ? 1.2 : 1.0)
                .shadow(color: Color.colorPink.opacity(selectedTab == index ? 0.5 : 0), radius: 10, x: 0, y: 4)
        } else {
            Image(imageName)
                .resizable()
                .scaledToFit()
                .frame(width: selectedTab == index ? 30 : 24,
                       height: selectedTab == index ? 30 : 24)
                .foregroundColor(.white)
                .padding(selectedTab == index ? 14 : 10)
                .background(
                    Circle()
                        .fill(Color.colorPink.opacity(selectedTab == index ? 1 : 0))
                )
                .scaleEffect(selectedTab == index ? 1.2 : 1.0)
                .shadow(color: Color.colorPink.opacity(selectedTab == index ? 0.5 : 0), radius: 10, x: 0, y: 4)
        }
    }

}



// MARK: - Preview
#Preview {
    MainTrainerTabView()
}
