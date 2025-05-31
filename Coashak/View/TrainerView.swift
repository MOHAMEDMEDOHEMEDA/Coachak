//
//  TrainerProfileView 2.swift
//  Coashak
//
//  Created by Mohamed Magdy on 11/05/2025.
//

import SwiftUICore
import SwiftUI


// MARK: - Main View
struct TrainerView: View {
    let trainer: TrainerProfile
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // Profile Image
                Image(trainer.profileImageName)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 200)
                    .clipped()
                    .padding(.bottom, 8)
                
                // Trainer Name and Tags
                VStack(alignment: .leading, spacing: 8) {
                    Text(trainer.name)
                        .font(.title)
                        .fontWeight(.bold)
                    
                    // Example tags, replace with actual data
                    HStack {
                        Text("Yoga").modifier(TagStyle())
                        Text("Bulking").modifier(TagStyle())
                        Text("Fitness").modifier(TagStyle())
                    }
                }
                .padding(.horizontal)
                
                // Bio
                VStack(alignment: .leading, spacing: 4) {
                    Text("Bio")
                        .font(.headline)
                    Text(trainer.bio)
                        .fontWeight(.bold)
                        .foregroundColor(.gray)
                }
                .padding(.horizontal)
                
                // Email
                VStack(alignment: .leading, spacing: 4) {
                    Text("Email")
                        .font(.headline)
                    Text(trainer.email)
                        .fontWeight(.bold)
                        .foregroundColor(.gray)
                }
                .padding(.horizontal)
                
                // Experience
                VStack(alignment: .leading, spacing: 4) {
                    Text("Experience")
                        .font(.headline)
                    Text("\(trainer.experienceYears) years")
                        .fontWeight(.bold)
                        .foregroundColor(.gray)
                }
                .padding(.horizontal)
                
                // Certifications
                VStack(alignment: .leading, spacing: 8) {
                    Text("Certifications")
                        .font(.headline)

                    ForEach(trainer.certifications, id: \.self) { certification in
                        HStack(spacing: 8) {
                            Image(systemName: "checkmark.circle.fill")
                                .resizable()
                                .frame(width: 16, height: 16)
                                .foregroundColor(Color.colorPurple)

                            Text(certification)
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundColor(.gray)
                        }
                    }

                }
                .padding(.horizontal)

                // Availability
                VStack(alignment: .leading, spacing: 4) {
                    Text("Availability")
                        .font(.headline)
                    Text(trainer.availability)
                        .fontWeight(.bold)
                        .foregroundColor(.gray)
                }
                .padding(.horizontal)
                
                // Reviews Section
                VStack(alignment: .leading, spacing: 8) {
                    Text("Reviews")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .padding(.horizontal)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) {
                            ForEach(trainer.reviews) { review in
                                ReviewCardView(review: review)
                            }
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 8) // Padding for scrollbar if visible and content
                    }
                }
                // Subscribe Button
                Button(action: {
                    // Handle subscription action
                }) {
                    Text("Subscribe")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.colorMidPink)
                        .cornerRadius(10)
                }
                .padding(.horizontal)
                .padding(.bottom, 20) // Add padding to the bottom
            }
        }
        .navigationTitle("Trainer Profile")
    }
}

// MARK: - Helper View Modifier for Tags
struct TagStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(Color.gray.opacity(0.0))
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.gray.opacity(0.6), lineWidth: 2) // Light gray border
            )
            .shadow(radius: 0.9)
            .font(.caption)
    }
}

// MARK: - Example Usage
struct TrainerProfileView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleTrainer = TrainerProfile(
            name: "mohamed magdy",
            bio: "Passionate about helping individuals find balance and well-being through the practice of yoga and meditation. Experienced in guiding students of all levels.",
            email: "mo.magdy@gmail.com",
            experienceYears: 8,
            certifications: ["ACE Certified Personal Trainer", "Certified Nutrition Specialist"],
            availability: "Weekdays: 7:00 AM - 7:00 PM\nWeekends: 7:00 AM - 7:00 PM",
            rating: 4.5, reviews: [Review(reviewerName: "mohamed magdy", rating: 4, comment: "good trainer"),Review(reviewerName: "mohamed khaled", rating: 3, comment: "fair")],
            profileImageName: "edited_profile_upwork" // Replace with actual image name or URL
        )
        NavigationView {
            TrainerView(trainer: sampleTrainer)
        }
    }
}
