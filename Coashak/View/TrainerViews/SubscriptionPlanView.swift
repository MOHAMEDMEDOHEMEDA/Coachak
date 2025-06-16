//
//  SubscriptionPlanViews.swift
//  Coashak
//
//  Created by Mohamed Magdy on 06/04/2025.
//

// MARK: - Subscription Plans View
import SwiftUI

struct TrainerSubscriptionPlansView: View {
    @StateObject private var viewModel = CreatePlanViewModel()
    @State private var navigateToCreationOfPlan: Bool = false

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                // Summary Cards
                HStack(spacing: 12) {
                    SummaryCardView(
                        title: "Total Plans",
                        value: String(viewModel.plans.count),
                        icon: "doc.text.fill",
                        backgroundColor: Color.pink.opacity(0.2),
                        iconColor: Color.pink.opacity(0.7)
                    )

                    SummaryCardView(
                        title: "Active Clients",
                        value: "24",
                        icon: "person.2.fill",
                        backgroundColor: Color.purple.opacity(0.2),
                        iconColor: Color.purple.opacity(0.7)
                    )
                }

                // Plan List with working NavigationLink
                ForEach(viewModel.plans) { plan in
                    NavigationLink(destination: PlanDetailsAndSubscribersView(plan: plan)) {
                        PlanDetailSection(plan: plan)
                    }
                    .buttonStyle(PlainButtonStyle())
                }

                // Create New Plan Button
                Button(action: {
                    navigateToCreationOfPlan = true
                }) {
                    HStack {
                        Image(systemName: "plus")
                        Text("Create a new plan")
                    }
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(
                        LinearGradient(
                            colors: [Color.pink.opacity(0.2), Color.purple.opacity(0.2)],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(28)
                }
                .padding(.top, 8)
            }
            .padding(.horizontal)
            .padding(.bottom, 100)
        }
        .navigationTitle("Subscription Plans")
        .navigationBarTitleDisplayMode(.inline)
//        .navigationDestination(for: PlanForResponse.self) { plan in
//            PlanDetailsAndSubscribersView(plan: plan)
//        }
        .sheet(isPresented: $navigateToCreationOfPlan) {
            CreatePlanView()
                .presentationDetents([.medium, .large]) // Optional: controls sheet height
        }

        .onAppear {
            Task {
                await viewModel.fetchPlans()
            }
        }
    }
}



// MARK: - Summary Card View
struct SummaryCardView: View {
    let title: String
    let value: String
    let icon: String
    let backgroundColor: Color
    let iconColor: Color
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Text(value)
                    .font(.title)
                    .fontWeight(.bold)
            }
            
            Spacer()
            
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(iconColor)
        }
        .padding()
        .background(backgroundColor)
        .cornerRadius(12)
        .frame(maxWidth: .infinity)
    }
}

//// MARK: - Plan Card View
//struct TrainerPlanCardView: View {
//    let plan: PlanForResponse
//    
//    var body: some View {
//        VStack(spacing: 0) {
//            // Plan Info
//            VStack(alignment: .leading, spacing: 12) {
//                // Title and Price
//                HStack {
//                    Text(plan.title)
//                        .font(.headline)
//                    
//                    Spacer()
//                    
//                    Text("\(plan.price) $")
//                        .font(.subheadline)
//                        .padding(.horizontal, 8)
//                        .padding(.vertical, 4)
//                        .background(Color.pink.opacity(0.05))
//                        .foregroundColor(.pink)
//                        .cornerRadius(8)
//                }
//                
//                // Status and Client Count
//                HStack {
//                    Text(plan.hasTrainingPlan ? "Training Plan" : "No Training Plan")
//                        .font(.caption)
//                        .padding(.horizontal, 12)
//                        .padding(.vertical, 4)
//                        .background(Color.pink.opacity(0.05))
//                        .foregroundColor(.pink)
//                        .cornerRadius(12)
//                    
//                    Text(plan.hasNutritionPlan ? "nutrition Plan" : "No nutrition Plan")
//                        .font(.caption)
//                        .padding(.horizontal, 12)
//                        .padding(.vertical, 4)
//                        .background(Color.pink.opacity(0.05))
//                        .foregroundColor(.pink)
//                        .cornerRadius(12)
//                }
//                
//                // Description
//                Text(plan.description)
//                    .font(.subheadline)
//                    .foregroundColor(.secondary)
//                    .lineLimit(2)
//            }
//            .padding()
//            
//            Divider()
//            
//            // Action Buttons
//            HStack {
//                // Edit Button
//                Button(action: {
//                    print("Edit button tapped for plan: \(plan.title)")
//                    // TODO: Implement actual edit action, e.g., navigate to an edit view
//                }) {
//                    HStack {
//                        Image(systemName: "square.and.pencil")
//                            .foregroundColor(.purple)
//                        
//                        Text("Edit")
//                            .foregroundColor(.purple)
//                            .font(.subheadline)
//                    }
//                    .frame(maxWidth: .infinity)
//                }
//                
//                Divider()
//                    .frame(height: 24)
//                
//                // Clients Button
//                Button(action: {
//                    print("Clients button tapped for plan: \(plan.title)")
//                    // TODO: Implement actual clients action, e.g., navigate to a client list for this plan
//                }) {
//                    HStack {
//                        Image(systemName: "person.2.fill")
//                            .foregroundColor(.purple)
//
//                        Text("Clients")
//                            .foregroundColor(.purple)
//                            .font(.subheadline)
//                    }
//                    .frame(maxWidth: .infinity)
//                }
//            }
//            .padding(.vertical, 12)
//            .background(Color.pink.opacity(0.1))
//        }
//        .background(Color.white)
//        .cornerRadius(12)
//        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
//    }
//}

// MARK: - Preview Helpers

import Foundation

struct PlanPreviewData {
    static let sample = PlanForResponse(
        id: "1",
        trainer: "123",
        title: "Elite Monthly Plan",
        description: "Includes weekly personal training sessions, a nutrition guide, and progress tracking.",
        price: 49,
        durationInWeeks: 4,
        hasTrainingPlan: true,
        hasNutritionPlan: true,
        createdAt: Date(),
        updatedAt: Date(),
        v: 0
    )
}

struct ClientPreviewData {
    static let full = ClientSub(
        id: "1",
        fullName: "Jane Doe",
        profilePhoto: "https://randomuser.me/api/portraits/women/44.jpg"
    )
}

struct PlanSubPreviewData {
    static let short = PlanSub(
        id: "1",
        title: "Elite Monthly Plan"
    )
}

struct TrainerPreviewData {
    static let sample = TrainerSub(
        id: "trainer123",
        fullName: "John Coach"
    )
}

struct SubscriptionPreviewData {
    static let one = Subscription(
        id: "sub1",
        status: "active",
        trainingPlan: ["Workout 1", "Workout 2"],
        nutritionPlan: ["Meal Plan 1"],
        startedAt: "2025-06-01T00:00:00Z",
        expiresAt: "2025-07-01T00:00:00Z",
        createdAt: "2025-06-01T00:00:00Z",
        updatedAt: "2025-06-01T00:00:00Z",
        active: true,
        daysUntilExpire: 19,
        client: ClientPreviewData.full,
        trainer: TrainerPreviewData.sample,
        plan: PlanSubPreviewData.short
    )
}
// MARK: - Previews



#Preview("Subscription Card View") {
    SubscriptionCardView(subscription: SubscriptionPreviewData.one)
}
