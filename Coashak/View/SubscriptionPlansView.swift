//
//  SubscribtionPlansView.swift
//  Coashak
//
//  Created by Mohamed Magdy on 06/04/2025.
//

import SwiftUI

struct SubscriptionPlansView: View {
    @State private var selectedPlan: String = "Monthly"

        var body: some View {
            ScrollView {
                VStack(spacing: 16) {
                    // Header
                    HStack {
                        Button(action: {}) {
                            Image(systemName: "chevron.left")
                                .foregroundColor(.black)
                        }
                        Spacer()
                    }
                    .padding(.horizontal)

                    Text("Plans")
                        .font(.title)
                        .bold()

                    // Coach Image
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

                    // Plans
                    VStack(spacing: 16) {
                        PlanCardView(title: "Monthly Subscription", price: "$30", features: ["Weekly Progress Tracking", "Coaching Support", "Personalized Training Program"], isSelected: selectedPlan == "Monthly", isCurrent: true) {
                            selectedPlan = "Monthly"
                        }

                        PlanCardView(title: "3-Months Subscription", price: "$75", features: ["Weekly Progress Tracking", "Coaching Support", "Personalized Training Program", "Tailored Nutrition Plan"], isSelected: selectedPlan == "3-Months", isCurrent: false) {
                            selectedPlan = "3-Months"
                        }

                        PlanCardView(title: "6-Months Subscription", price: "$150", features: ["Weekly Progress Tracking", "Coaching Support", "Personalized Training Program", "Tailored Nutrition Plan"], isSelected: selectedPlan == "6-Months", isCurrent: false) {
                            selectedPlan = "6-Months"
                        }
                    }
                    .padding(.horizontal)

                    // Bottom Section
                    VStack(spacing: 8) {
                        Text("Unlock your potential with expert guidance and proven strategies for success.")
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)

                        HStack {
                            Image(systemName: "star.fill")
                                .foregroundColor(.yellow)
                            Text("4.5  700+ reviews")
                        }

                        // Reviews
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 2), spacing: 12) {
                            ForEach(0..<4) { _ in
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Rawan Shawky")
                                        .font(.caption)
                                        .bold()
                                    HStack(spacing: 2) {
                                        ForEach(0..<5) { _ in
                                            Image(systemName: "star.fill")
                                                .foregroundColor(.yellow)
                                                .font(.caption2)
                                        }
                                    }
                                    Text("The subscription is worth the price!")
                                        .font(.caption2)
                                }
                                .padding()
                                .background(Color.pink.opacity(0.2))
                                .cornerRadius(12)
                            }
                        }
                        .padding(.horizontal)

                        // Subscribe Button
                        Button(action: {
                            // Subscription action
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
                    .padding(.bottom, 30)
                }
            }
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

                if isCurrent {
                    Text("Current Plan")
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                        .background(Color.purple)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                } else {
                    Button(action: action) {
                        HStack {
                            Text("Upgrade")
                            Spacer()
                            Image(systemName: "arrow.right")
                        }
                        .padding(.vertical, 8)
                        .padding(.horizontal)
                        .background(Color.purple)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                    }
                }
            }
            .padding()
            .background(isSelected ? Color.purple.opacity(0.1) : Color.white)
            .cornerRadius(12)
            .overlay(RoundedRectangle(cornerRadius: 12).stroke(isSelected ? Color.purple : Color.gray.opacity(0.3)))
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

    #Preview {
        SubscriptionPlansView()
    }
