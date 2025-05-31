//
//  PlanDetailView.swift
//  Coashak
//
//  Created by Mohamed Magdy on 06/04/2025.
//


import SwiftUI

struct PlanDetailView: View {
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 16) {
                
                
                Text("3-Months Plan")
                    .font(.title)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .center)
                
                // Profile Image
                Image("edited_profile_upwork")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 200)
                    .clipped()
                    .padding(.bottom, 8)

                HStack {
                    Spacer()
                    Button(action: {
                        // Handle edit
                    }) {
                        HStack {
                            Image(systemName: "pencil")
                            Text("Edit")
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 8)
                        .background(Color.red.opacity(0.2))
                        .cornerRadius(12)
                    }
                }
                }

                // Coach Info
                Group {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Name")
                            .font(.headline)
                        Text("Mohamed magdy")

                        Text("Payment")
                            .font(.headline)
                            .padding(.top, 8)
                        Text("$30/Month")

                        Text("Nutrition Plan")
                            .font(.headline)
                            .padding(.top, 8)
                        Text("Will be received after the subscription")

                        Text("Availability")
                            .font(.headline)
                            .padding(.top, 8)
                        Text("Weekdays: 8 AM - 8 PM")
                        Text("Weekends: 12 PM - 8 PM")
                    }
                }

                // Plan Offers
                Text("This plan offers the following")
                    .font(.headline)
                    .padding(.top)

                VStack(spacing: 10) {
                    PlanOfferRow(icon: "📊", title: "Weekly Progress Tracking")
                    PlanOfferRow(icon: "🏋️‍♂️", title: "Personalized Training Program")
                    PlanOfferRow(icon: "💬", title: "Coaching Support")
                }
            }
            .padding()
        }
    }


struct PlanOfferRow: View {
    var icon: String
    var title: String

    var body: some View {
        HStack {
            Text(icon)
            Text(title)
            Spacer()
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}
#Preview{
    PlanDetailView()
}
