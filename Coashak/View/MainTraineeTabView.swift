//
//  MainTraineeTabView.swift
//  Coashak
//
//  Created by Mohamed Magdy on 24/04/2025.
//
import SwiftUI

struct MainTraineeTabView: View {
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
                    case 0: HomePageTraineeView()
                    case 1: MealPlanTraineeView()
                    case 2: TrainingPlanView()
                    case 3: TraineeProfileView()
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
                            tabItem(systemName: "house.fill", index: 0)
                            tabItem(systemName: "dumbbell.fill", index: 1)
                            tabItem(systemName: "person.3.fill", index: 2)
                            tabItem(systemName: "person.crop.circle", index: 3)
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
    
    func tabItem(systemName: String, index: Int) -> some View {
        Button(action: {
            withAnimation(.easeInOut) {
                selectedTab = index
            }
        }) {
            VStack {
                Image(systemName: systemName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: selectedTab == index ? 30 : 24,
                           height: selectedTab == index ? 30 : 24)
                    .foregroundColor(.white)
                    .padding(selectedTab == index ? 14 : 10) // Padding to prevent clipping
                    .background(
                        Circle()
                            .fill(Color.colorPink.opacity(selectedTab == index ? 1 : 0))
                    )
                    .scaleEffect(selectedTab == index ? 1.2 : 1.0)
                    .shadow(color: Color.colorPink.opacity(selectedTab == index ? 0.5 : 0), radius: 10, x: 0, y: 4)
            }
            .frame(maxWidth: .infinity)
            .padding(.bottom, 30) //  Extra bottom padding
        }
    }
}

// MARK: - Curved Tab Bar Shape
struct CustomCurveTabBarShape: Shape {
    var curveX: CGFloat
    
    var animatableData: CGFloat {
        get { curveX }
        set { curveX = newValue }
    }
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let curveWidth: CGFloat = 90
        let curveHeight: CGFloat = 35
        let midX = curveX
        
        path.move(to: .zero)
        path.addLine(to: CGPoint(x: midX - curveWidth / 2, y: 0))
        
        path.addQuadCurve(
            to: CGPoint(x: midX + curveWidth / 2, y: 0),
            control: CGPoint(x: midX, y: -curveHeight)
        )
        
        path.addLine(to: CGPoint(x: rect.maxX, y: 0))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: 0, y: rect.maxY))
        path.closeSubpath()
        
        return path
    }
}

// MARK: - Safe Array Access
extension Array {
    subscript(safe index: Int) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

// MARK: - Preview
#Preview {
    MainTraineeTabView()
}
