//
//  MainTraineeTabView.swift
//  Coashak
//
//  Created by Mohamed Magdy on 24/04/2025.
//
import SwiftUI

struct MainTraineeTabView: View {
    @State private var selectedTab = 0
    @State private var tabPositions: [CGFloat] = Array(repeating: 0, count: 5)
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
                    case 1: MealPlanFormView()
                    case 2: ChatView()
                    case 3:DailyScheduleView()
                    case 4: TraineeProfileView().environmentObject(ClientProfileViewModel())
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
                            tabItem(source: .local, imageName: "meal_plan", index: 1)
                            tabItem(source: .local, imageName: "Ai_icon", index: 2)
                            tabItem(source: .local, imageName: "nutrition_plan", index: 3)
                            tabItem(source: .system, imageName: "person.crop.circle", index: 4)
                        }
                        .frame(height: 70)
                        .background(
                            GeometryReader { geo in
                                Color.clear
                                    .onAppear {
                                        for i in 0..<5 {
                                            let buttonWidth = geo.size.width / 5
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
