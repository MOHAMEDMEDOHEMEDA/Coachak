//
//  Client.swift
//  Coashak
//
//  Created by Mohamed Magdy on 10/06/2025.
//

import SwiftUI

struct YourClientsView: View {
    @StateObject private var viewModel = SubscriptionsViewModel()
    @State private var hasAppeared = false  // To prevent multiple fetches on repeated appearances

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading) {
                    Text("\(viewModel.subscriptions.count) Clients")
                        .font(.title3)
                        .fontWeight(.medium)
                        .padding(.horizontal)

                    ForEach(viewModel.subscriptions, id: \.id) { sub in
                        ClientCard(subscription: sub)
                            .padding(.horizontal)
                            .padding(.bottom, 8)
                    }
                }
            }
            .navigationTitle("Your Clients")
            .onAppear {
                if !hasAppeared {
                    hasAppeared = true
                    Task {
                        await viewModel.fetchSubscriptions()
                    }
                }
            }
        }
    }
}

struct ClientCard: View {
    let subscription: Subscription

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 12) {
                AsyncImageSafe(urlString: subscription.client.profilePhoto)
                    .frame(width: 50, height: 50)
                    .clipShape(Circle())

                VStack(alignment: .leading, spacing: 4) {
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
                    Text(formatDate(subscription.startedAt))
                }

                Spacer()

                VStack(alignment: .leading) {
                    Text("End Date")
                        .font(.caption)
                        .foregroundColor(.gray)
                    Text(formatDate(subscription.expiresAt))
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
        .background(RoundedRectangle(cornerRadius: 12).fill(Color.white).shadow(color: .black.opacity(0.05), radius: 5))
    }

    func formatDate(_ isoDate: String) -> String {
        let formatter = ISO8601DateFormatter()
        if let date = formatter.date(from: isoDate) {
            let displayFormatter = DateFormatter()
            displayFormatter.dateStyle = .long
            return displayFormatter.string(from: date)
        }
        return isoDate
    }
}
struct AsyncImageSafe: View {
    let urlString: String?

    var body: some View {
        #if DEBUG
        if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1" {
            Image(systemName: "person.circle.fill")
                .resizable() // here!
                .foregroundColor(.gray)
        } else {
            actualImage
        }
        #else
        actualImage
        #endif
    }

    @ViewBuilder
    private var actualImage: some View {
        if let urlString = urlString,
           let url = URL(string: urlString) {
            AsyncImage(url: url) { image in
                image
                    .resizable() // apply here!
                    .scaledToFill()
            } placeholder: {
                Color.gray
            }
        } else {
            Color.gray
        }
    }
}

