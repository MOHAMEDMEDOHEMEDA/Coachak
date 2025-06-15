//
//  HomePageForTrainerView.swift
//  Coashak
//
//  Created by Mohamed Magdy on 20/01/2025.
//

import SwiftUI

// MARK: - Dashboard View
struct HomePageForTrainerView: View {
    @State private var upcomingSessions: [Session] = []
    @State private var pendingClients: [PendingClient] = []
    @State private var selectedSpecialties: Set<TrainingSpecialty> = []
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Quick Stats Section
                Text("Quick Stats")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.horizontal)
                
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                    QuickStatCard(
                        value: "24",
                        title: "Active Clients",
                        icon: "person.fill",
                        backgroundColor: Color.pink.opacity(0.2),
                        iconColor: Color.pink.opacity(0.7)
                    )
                    
                    QuickStatCard(
                        value: "18",
                        title: "Sessions this Week",
                        icon: "calendar",
                        backgroundColor: Color.purple.opacity(0.2),
                        iconColor: Color.purple.opacity(0.7)
                    )
                    
                    QuickStatCard(
                        value: "$1500",
                        title: "Monthly Earnings",
                        icon: "dollarsign.circle.fill",
                        backgroundColor: Color.purple.opacity(0.2),
                        iconColor: Color.purple.opacity(0.7)
                    )
                    
                    QuickStatCard(
                        value: "4.8",
                        title: "Average Rating",
                        icon: "star.fill",
                        backgroundColor: Color.pink.opacity(0.2),
                        iconColor: Color.pink.opacity(0.7)
                    )
                }
                .padding(.horizontal)
                
                // Upcoming Sessions Section
                VStack(alignment: .leading, spacing: 12) {
                    Text("Upcoming Sessions")
                        .font(.title3)
                        .fontWeight(.bold)
                        .padding(.horizontal)
                    
                    VStack(spacing: 12) {
                        ForEach(upcomingSessions) { session in
                            SessionCardView(session: session)
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical, 8)
                .background(Color.purple.opacity(0.1))
                .cornerRadius(16)
                .padding(.horizontal)
                
                // Pending Clients Section
                VStack(alignment: .leading, spacing: 12) {
                    Text("Pending Clients")
                        .font(.title3)
                        .fontWeight(.bold)
                        .padding(.horizontal)
                    
                    VStack(spacing: 16) {
                        ForEach(pendingClients) { client in
                            PendingClientCardView(client: client)
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical, 8)
                .background(Color.pink.opacity(0.1))
                .cornerRadius(16)
                .padding(.horizontal)
                
                // Training Specialties Section
                VStack(alignment: .leading, spacing: 12) {
                    Text("Your Training Specialties")
                        .font(.title3)
                        .fontWeight(.bold)
                        .padding(.horizontal)
                    
                    Text("Select the sports you would like to offer for training")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .padding(.horizontal)
                    
                    // Specialties Grid
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                        ForEach(TrainingSpecialty.allCases, id: \.self) { specialty in
                            SpecialtyCardView(
                                specialty: specialty,
                                isSelected: selectedSpecialties.contains(specialty),
                                onToggle: { toggleSpecialty(specialty) }
                            )
                        }
                    }
                    .padding(.horizontal)
                    
                    // Action Buttons
                    HStack {
                        Button(action: {
                            // Add more specialties
                        }) {
                            HStack {
                                Image(systemName: "plus.circle.fill")
                                    .foregroundColor(.pink)
                                Text("Add more")
                                    .foregroundColor(.black)
                            }
                            .padding()
                            .frame(maxWidth: .infinity)
                        }
                        
                        Button(action: {
                            // Save changes
                        }) {
                            Text("Save Changes")
                                .foregroundColor(.black)
                                .padding()
                                .frame(maxWidth: .infinity)
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical, 8)
                .background(Color.purple.opacity(0.1))
                .cornerRadius(16)
                .padding(.horizontal)
            }
            .padding(.vertical)
        }
        .onAppear {
            loadSampleData()
        }
    }
    
    private func toggleSpecialty(_ specialty: TrainingSpecialty) {
        if selectedSpecialties.contains(specialty) {
            selectedSpecialties.remove(specialty)
        } else {
            selectedSpecialties.insert(specialty)
        }
    }
    
    private func loadSampleData() {
        // Sample upcoming sessions
        upcomingSessions = [
            Session(
                id: UUID(),
                type: "Personal Training",
                clientName: "Sarah Mohammed",
                time: "10:00 AM",
                date: "Today"
            ),
            Session(
                id: UUID(),
                type: "Swim Coaching",
                clientName: "Sarah Mohammed",
                time: "10:00 AM",
                date: "Today"
            )
        ]
        
        // Sample pending clients
        pendingClients = [
            PendingClient(
                id: UUID(),
                name: "Client Name",
                trainingPlanCreated: false,
                nutritionPlanCreated: true,
                actionNeeded: true
            ),
            PendingClient(
                id: UUID(),
                name: "Client Name",
                trainingPlanCreated: false,
                nutritionPlanCreated: false,
                actionNeeded: false
            )
        ]
        
        // Sample selected specialties
        selectedSpecialties = [.cardio, .gainWeight, .loseWeight]
    }
}

// MARK: - Quick Stat Card
struct QuickStatCard: View {
    let value: String
    let title: String
    let icon: String
    let backgroundColor: Color
    let iconColor: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Spacer()
                Image(systemName: icon)
                    .font(.headline)
                    .foregroundColor(iconColor)
            }
            
            Text(value)
                .font(.title)
                .fontWeight(.bold)
            
            Text(title)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(backgroundColor)
        .cornerRadius(12)
    }
}

// MARK: - Session Card View
struct SessionCardView: View {
    let session: Session
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(session.type)
                    .font(.headline)
                
                Text(session.clientName)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text(session.time)
                    .font(.headline)
                
                Text(session.date)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 2)
    }
}

// MARK: - Pending Client Card View
struct PendingClientCardView: View {
    let client: PendingClient
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                // Client Avatar and Name
                HStack {
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .foregroundColor(.purple.opacity(0.7))
                    
                    Text(client.name)
                        .font(.headline)
                }
                
                Spacer()
                
                // Action Button
                Button(action: {
                    // Handle action
                }) {
                    Text(client.actionNeeded ? "Start Training" : "Create Plans")
                        .font(.subheadline)
                        .foregroundColor(.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.purple)
                        .cornerRadius(16)
                }
            }
            
            // Plan Status
            HStack(spacing: 12) {
                // Training Plan Status
                PlanStatusView(
                    title: "Training Plan",
                    isCreated: client.trainingPlanCreated
                )
                
                // Nutrition Plan Status
                PlanStatusView(
                    title: "Nutrition Plan",
                    isCreated: client.nutritionPlanCreated
                )
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 2)
    }
}

// MARK: - Plan Status View
struct PlanStatusView: View {
    let title: String
    let isCreated: Bool
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subheadline)
                
                Text(isCreated ? "Created" : "Not Created")
                    .font(.caption)
                    .foregroundColor(isCreated ? .purple : .secondary)
            }
            
            Spacer()
            
            Image(systemName: isCreated ? "checkmark.circle.fill" : "circle")
                .foregroundColor(isCreated ? .purple : .secondary.opacity(0.5))
        }
        .padding()
        .background(Color.purple.opacity(0.1))
        .cornerRadius(8)
    }
}

// MARK: - Specialty Card View
struct SpecialtyCardView: View {
    let specialty: TrainingSpecialty
    let isSelected: Bool
    let onToggle: () -> Void
    
    var body: some View {
        Button(action: onToggle) {
            VStack(spacing: 12) {
                HStack {
                    Spacer()
                    
                    Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                        .foregroundColor(isSelected ? .pink : .secondary)
                }
                
                Image(systemName: specialty.iconName)
                    .font(.title)
                    .foregroundColor(.black)
                
                Text(specialty.displayName)
                    .font(.headline)
                
                Text(isSelected ? "Selected" : "Not Selected")
                    .font(.caption)
                    .foregroundColor(isSelected ? .pink : .secondary)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(isSelected ? Color.pink.opacity(0.2) : Color.white)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.gray.opacity(0.2), lineWidth: 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Data Models
struct Session: Identifiable {
    let id: UUID
    let type: String
    let clientName: String
    let time: String
    let date: String
}

struct PendingClient: Identifiable {
    let id: UUID
    let name: String
    let trainingPlanCreated: Bool
    let nutritionPlanCreated: Bool
    let actionNeeded: Bool
}

enum TrainingSpecialty: String, CaseIterable {
    case fitness = "Fitness"
    case cardio = "Cardio"
    case gainWeight = "Gain Weight"
    case loseWeight = "Lose Weight"
    case yoga = "Yoga"
    case gymnastics = "Gymnastics"
    
    var displayName: String {
        return rawValue
    }
    
    var iconName: String {
        switch self {
        case .fitness:
            return "figure.strengthtraining.traditional"
        case .cardio:
            return "figure.run"
        case .gainWeight:
            return "figure.arms.open"
        case .loseWeight:
            return "figure.walk"
        case .yoga:
            return "figure.mind.and.body"
        case .gymnastics:
            return "figure.gymnastics"
        }
    }
}

// MARK: - Preview
struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        HomePageForTrainerView()
    }
}
