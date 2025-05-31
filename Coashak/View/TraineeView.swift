//
//  TraineeView.swift
//  Coashak
//
//  Created by Mohamed Magdy on 12/05/2025.
//

import Foundation
import SwiftUI


// MARK: - Trainee View
struct TraineeView: View {
    let trainee: TraineeProfile
    
    var body: some View {
        VStack(spacing: 0) {
          
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    
                    // Trainee Photo Placeholder
                    Image(trainee.photoPlaceholder)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 200)
                        .clipped()
                        .padding(.bottom, 8)
                    
                    // Personal Details
                    Group {
                        detailRow(label: "Name", value: trainee.name)
                        detailRow(label: "Age", value: "\(trainee.age) Years")
                        detailRow(label: "Fitness Level", value: trainee.fitnessLevel)
                        detailRow(label: "Goal", value: trainee.goal)
                    }
                    .padding(.horizontal)
                    
                    Divider()
                        .padding(.vertical, 8)
                    
                    // Health Overview
                    Text("Health Overview")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .padding(.horizontal)
                        .padding(.bottom, 4)
                    
                    Group {
                        detailRow(label: "Weight", value: trainee.weight)
                        detailRow(label: "Height", value: trainee.height)
                        detailRow(label: "Calories per day", value: trainee.caloriesPerDay)
                    }
                    .padding(.horizontal)
                    
                    // Health Conditions
                    tagSection(title: "Health conditions", tags: trainee.healthConditions)
                        .padding(.horizontal)
                    
                    // Allergies
                    tagSection(title: "Allergies", tags: trainee.allergies)
                        .padding(.horizontal)
                    
                    Spacer() // Pushes button to bottom if content is short
                }
                .padding(.vertical) // Add some vertical padding for the ScrollView content
            }
            
            // Start Training Button
            Button(action: {
                // Action for starting training
                print("Start Training button tapped")
            }) {
                Text("Start Training")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color(red: 235/255, green: 135/255, blue: 135/255)) // Pinkish color
                    .cornerRadius(12)
            }
            .padding()
        }
        .navigationTitle("Trainee View") 
    }
    
    // Helper view for detail rows (Label: Value)
    @ViewBuilder
    private func detailRow(label: String, value: String) -> some View {
        HStack(alignment: .top) {
            Text("\(label):")
                .font(.headline)
                .fontWeight(.medium)
            Text(value)
                .font(.body)
                .foregroundColor(.secondary)
            Spacer()
        }
    }
    
    // Simple tag section
    @ViewBuilder
    private func tagSection(title: String, tags: [String]) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
                .fontWeight(.medium)
            
            if !tags.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(tags, id: \.self) { tag in
                            Text(tag)
                                .modifier(TagStyle())
                        }
                    }
                }
            } else {
                Text("None")
                    .foregroundColor(.secondary)
                    .italic()
            }
        }
    }
}



// MARK: - Preview
struct TraineeView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleTrainee = TraineeProfile(
            photoPlaceholder: "edited_profile_upwork",
            name: "Ahmed magdy",
            age: 37,
            fitnessLevel: "Intermediate, Advanced",
            goal: "eg. Lose 10kg in 3 months",
            weight: "60 KG",
            height: "170 cm",
            caloriesPerDay: "1700 cal",
            healthConditions: ["Asthma", "Diabetes"],
            allergies: ["Asthma", "Diabetes"]
        )
        NavigationView {
            TraineeView(trainee: sampleTrainee)
        }
    }
}
