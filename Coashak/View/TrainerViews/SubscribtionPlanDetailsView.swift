//
//  SwiftUIView.swift
//  Coashak
//
//  Created by Mohamed Magdy on 13/06/2025.
//

import SwiftUI

struct PlanDetailsAndSubscribersView: View {
    let plan: PlanForResponse
    @StateObject private var viewModel = SubscriptionsViewModel()

    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                // MARK: - Plan Info Section
                PlanDetailSection(plan: plan)

                // MARK: - Subscribers Section
                SubscribersSection(planID: plan.id, subscriptions: viewModel.subscriptions)
            }
            .padding()
        }
        .navigationTitle("Plan Details")
        .navigationBarTitleDisplayMode(.inline)
        .background(Color(.systemGroupedBackground).ignoresSafeArea())
        .task {
            await viewModel.fetchSubscriptions()
        }
    }
}

struct PlanDetailSection: View {
    let plan: PlanForResponse

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text(plan.title)
                    .font(.title2)
                    .fontWeight(.bold)

                Spacer()

                Text("\(plan.price) $")
                    .font(.subheadline)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(Color.pink.opacity(0.1))
                    .foregroundColor(.pink)
                    .cornerRadius(10)
            }

            VStack(alignment: .leading, spacing: 6) {
                Text("Description")
                    .font(.headline)
                Text(plan.description)
                    .font(.body)
                    .foregroundColor(.secondary)
            }

            HStack(spacing: 10) {
                TagView(text: plan.hasTrainingPlan ? "Training Plan" : "No Training Plan")
                    .background(plan.hasTrainingPlan ? Color.green.opacity(0.15) : Color.red.opacity(0.15))
                    .foregroundColor(plan.hasTrainingPlan ? .green : .red)

                TagView(text: plan.hasNutritionPlan ? "Nutrition Plan" : "No Nutrition Plan")
                    .background(plan.hasNutritionPlan ? Color.green.opacity(0.15) : Color.red.opacity(0.15))
                    .foregroundColor(plan.hasNutritionPlan ? .green : .red)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
}

struct SubscribersSection: View {
    let planID: String
    let subscriptions: [Subscription]

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Subscribers")
                .font(.headline)
                .padding(.leading, 4)

            let filteredSubscriptions = subscriptions.filter { $0.plan.id == planID }

            if filteredSubscriptions.isEmpty {
                Text("No subscribers yet.")
                    .foregroundColor(.gray)
                    .padding(.top, 8)
            } else {
                ForEach(filteredSubscriptions) { subscription in
                    SubscriptionCardView(subscription: subscription)
                }
            }
        }
    }
}

// MARK: - Client Card View

struct SubscriptionCardView: View {
    let subscription: Subscription

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 12) {
                AsyncImage(url: URL(string: subscription.client.profilePhoto)) { image in
                    image.resizable()
                } placeholder: {
                    Circle().fill(Color.gray.opacity(0.3))
                }
                .frame(width: 48, height: 48)
                .clipShape(Circle())

                VStack(alignment: .leading, spacing: 2) {
                    Text(subscription.client.fullName)
                        .font(.headline)
                    Text(subscription.plan.title)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }

            HStack {
                VStack(alignment: .leading) {
                    Text("Start Date")
                        .font(.caption)
                        .foregroundColor(.gray)
                    Text(formattedDate(subscription.startedAt))
                        .font(.subheadline)
                }

                Spacer()

                VStack(alignment: .leading) {
                    Text("End Date")
                        .font(.caption)
                        .foregroundColor(.gray)
                    Text(formattedDate(subscription.expiresAt))
                        .font(.subheadline)
                }
            }

            HStack {
                NavigationLink(destination: TraineeView(id: subscription.client.id)) {
                    Label("Details", systemImage: "person.fill")
                        .foregroundColor(.purple)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                        .background(Color.purple.opacity(0.1))
                        .cornerRadius(8)
                }

                NavigationLink(destination: PlanSwitcherView(id: subscription.client.id)) {
                    Label("Plans", systemImage: "newspaper")
                        .foregroundColor(.pink)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                        .background(Color.pink.opacity(0.1))
                        .cornerRadius(8)
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
    }

    func formattedDate(_ isoString: String) -> String {
        let isoFormatter = ISO8601DateFormatter()
        if let date = isoFormatter.date(from: isoString) {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy mm dd"
            return formatter.string(from: date)
        }
        return isoString
    }
}

struct TagView: View {
    let text: String

    var body: some View {
        Text(text)
            .font(.caption)
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(Color.purple.opacity(0.1))
            .foregroundColor(.purple)
            .cornerRadius(12)
    }
}
