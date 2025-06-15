//
//  SubscribtionPlansView.swift
//  Coashak
//
//  Created by Mohamed Magdy on 06/04/2025.
//

import SwiftUI

struct SubscriptionPlansView: View {
    @StateObject private var SubscribeVM = SubscriptionClientViewModel()
    @StateObject private var viewModel = TrainerPlansViewModel()
    @State private var selectedPlanId: String?
    @State private var showAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""

    let trainerId: String

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                // Header
//                HStack {
//                    Button(action: {}) {
//                        Image(systemName: "chevron.left")
//                            .foregroundColor(.black)
//                    }
//                    Spacer()
//                }
//                .padding(.horizontal)

                Text("Plans")
                    .font(.title)
                    .bold()

                // Coach Info (Placeholder)
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: 150, height: 150)
                    .overlay(Text("Coach Image"))

                Text("Name")
                    .font(.title3)
                    .bold()
                Text("Coach Name")
                    .font(.subheadline)
                    .foregroundColor(.gray)

                // Dynamic Plans
                if viewModel.isLoading {
                    ProgressView("Loading Plans...")
                } else {
                    VStack(spacing: 16) {
                        ForEach(viewModel.plans) { plan in
                            PlanCardView(
                                title: plan.title,
                                price: "$\(plan.price)",
                                features: buildFeatures(from: plan),
                                isSelected: selectedPlanId == plan.id,
                                isCurrent: false
                            ) {
                                selectedPlanId = plan.id
                            }
                        }
                    }
                    .padding(.horizontal)
                }

                // Subscribe Button
                Button(action: {
                    guard let selectedPlanId = selectedPlanId else {
                        alertTitle = "Missing Selection"
                             alertMessage = "Please select a plan first."
                             showAlert = true
                        return
                    }

                    SubscribeVM.subscribeToPlan(planId: selectedPlanId) { result in
                           switch result {
                           case .success(let message):
                               alertTitle = "✅ Subscription Successful"
                               alertMessage = message
                               showAlert = true
                           case .failure(let error):
                               alertTitle = "❌ Subscription Failed"
                               alertMessage = error.localizedDescription
                               showAlert = true
                           }
                    }
                }) {
                    Text("Subscribe Now")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.purple)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
                .padding(.horizontal)
            }
        }
        .onAppear {
            viewModel.fetchPlans(for: trainerId)
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text(alertTitle),
                message: Text(alertMessage),
                dismissButton: .default(Text("OK"))
            )
        }

    }

    private func buildFeatures(from plan: PlanClientsForResponse) -> [String] {
        var features = [String]()
        features.append("Duration: \(plan.durationInWeeks) weeks")
        if plan.hasTrainingPlan { features.append("Personalized Training Program") }
        if plan.hasNutritionPlan { features.append("Tailored Nutrition Plan") }
        return features
    }
}


struct PlanCardView: View {
        let title: String
        let price: String
        let features: [String]
        let isSelected: Bool
        let isCurrent: Bool
        let action: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: isSelected ? "largecircle.fill.circle" : "circle")
                    .foregroundColor(.purple)
                Text(title)
                    .bold()
                Spacer()
                Text(price)
                    .bold()
            }

            ForEach(features, id: \.self) { feature in
                HStack {
                    Text(featureIcon(for: feature))
                    Text(feature)
                }
            }

        }
        .padding()
        .background(isSelected ? Color.purple.opacity(0.1) : Color.white)
        .cornerRadius(12)
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(isSelected ? Color.purple : Color.gray.opacity(0.3)))
        .onTapGesture {
            action() // <-- ✅ This enables selection
        }
    }


        private func featureIcon(for feature: String) -> String {
            switch feature {
            case _ where feature.contains("Tracking"): return "📊" // bar chart
            case _ where feature.contains("Support"): return "💬" // speech balloon
            case _ where feature.contains("Program"): return "🤼" // wrestling
            case _ where feature.contains("Nutrition"): return "🍎" // apple
            default: return "•"
            }
        }
    }

struct CustomToastView: View {
    let title: String
    let message: String
    let isSuccess: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: isSuccess ? "checkmark.seal.fill" : "xmark.octagon.fill")
                    .foregroundColor(isSuccess ? .green : .red)
                Text(title)
                    .font(.headline)
                    .foregroundColor(.primary)
            }
            Text(message)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(16)
        .shadow(radius: 8)
        .padding(.horizontal)
    }
}

struct CustomToastModifier: ViewModifier {
    @Binding var isPresented: Bool
    let title: String
    let message: String
    let isSuccess: Bool

    func body(content: Content) -> some View {
        ZStack {
            content

            if isPresented {
                VStack {
                    CustomToastView(title: title, message: message, isSuccess: isSuccess)
                        .transition(.move(edge: .top).combined(with: .opacity))
                    Spacer()
                }
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        withAnimation {
                            isPresented = false
                        }
                    }
                }
                .zIndex(1)
            }
        }
        .animation(.spring(), value: isPresented)
    }
}

extension View {
    func customToast(isPresented: Binding<Bool>, title: String, message: String, isSuccess: Bool) -> some View {
        self.modifier(CustomToastModifier(isPresented: isPresented, title: title, message: message, isSuccess: isSuccess))
    }
}

