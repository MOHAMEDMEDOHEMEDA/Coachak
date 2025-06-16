//
//  TrainerSubscriptionPlansView.swift
//  Coashak
//
//  Created by Mohamed Magdy on 16/06/2025.
//

import SwiftUI

struct ClientPlanDetailsView: View {
    @StateObject private var viewModel = SubscriptionsViewModel()

    var body: some View {
        
            VStack {
                if viewModel.isLoading {
                    ProgressView("Loading...")
                        .padding()
                } else if let error = viewModel.errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                } else {
                    ScrollView {
                        VStack(spacing: 16) {
                            ForEach(viewModel.subscriptions) { subscription in
                                NavigationLink(destination: DailyScheduleView(trainer: subscription.trainer.id, userId: subscription.client.id)) {
                                    ClientSubscriptionCard(subscription: subscription)
                                }
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("My Plans")
            .task {
                await viewModel.fetchSubscriptions()
            }
//            .navigationDestination(for: String.self) { trainerID in
//                DailyScheduleView(trainer: trainerID)
//            }
        
    }
}

struct ClientSubscriptionCard: View {
    let subscription: Subscription

    var statusText: String {
        subscription.status.lowercased() == "true" ? "Active" : "Expired"
    }

    var statusColor: Color {
        subscription.status.lowercased() == "true" ? .green : .red
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(subscription.plan.title)
                    .font(.title3)
                    .fontWeight(.semibold)
                Spacer()
                Text(statusText)
                    .font(.caption)
                    .foregroundColor(statusColor)
            }

            Text("Trainer: \(subscription.trainer.fullName)")
                .font(.subheadline)
                .foregroundColor(.secondary)

            Text("Expires in \(subscription.daysUntilExpire) days")
                .font(.footnote)
                .foregroundColor(.gray)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: .gray.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}

