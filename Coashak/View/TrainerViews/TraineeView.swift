//
//  TraineeView.swift
//  Coashak
//
//  Created by Mohamed Magdy on 12/05/2025.
//

import Foundation
import SwiftUI


struct TraineeView: View {
    let id: String
    @StateObject private var viewModel = UserProfileViewModel()
    
    var body: some View {
        VStack{
            if viewModel.isLoading {
                ProgressView("Loading trainee...")
            } else if let trainee = viewModel.trainee {
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        AsyncImage(url: URL(string: trainee.profilePhoto)) { phase in
                            if let image = phase.image {
                                image.resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(height: 200)
                                    .clipped()
                            } else if phase.error != nil {
                                // Error view
                                Color.red.opacity(0.3)
                                    .frame(height: 200)
                            } else {
                                // Placeholder
                                Color.gray.opacity(0.3)
                                    .frame(height: 200)
                            }
                        }
                        .cornerRadius(12)
                        .padding(.bottom, 8)
                        
                        
                        VStack(spacing: 8) {
                            detailRow(label: "Name", value: trainee.name)
                            detailRow(label: "Age", value: "\(trainee.age) Years")
                            detailRow(label: "Fitness Level", value: trainee.fitnessLevel)
                            detailRow(label: "Goal", value: trainee.fitnessGoal)
                            detailRow(label: "Weight", value: trainee.weightText)
                            detailRow(label: "Height", value: trainee.heightText)
                        }
                        .padding(.horizontal)
                        
                        tagSection(title: "Health Conditions", tags: trainee.healthCondition)
                            .padding(.horizontal)
                        tagSection(title: "Allergies", tags: trainee.allergy)
                            .padding(.horizontal)
                    }
                    .padding(.vertical)
                }
            } else if let error = viewModel.errorMessage {
                Text(error)
                    .foregroundColor(.red)
                    .padding()
            }
        }
        .navigationTitle("Trainee View")
        .onAppear {
            viewModel.fetchUserProfile(userId: id)
        }
    }
     
    
    @ViewBuilder
    private func detailRow(label: String, value: String) -> some View {
        HStack {
            Text("\(label):").bold()
            Spacer()
            Text(value).foregroundColor(.secondary)
        }
    }
    
    @ViewBuilder
    private func tagSection(title: String, tags: [String]) -> some View {
        VStack(alignment: .leading) {
            Text(title).font(.headline)
            if tags.isEmpty {
                Text("None").italic().foregroundColor(.secondary)
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(tags, id: \.self) {
                            Text($0).padding(8)
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(8)
                        }
                    }
                }
            }
        }
    }
}
extension UserProfile {
    var age: Int {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd" // adjust if backend sends a different format
        guard let birthDate = formatter.date(from: dateOfBirth) else { return 0 }

        let now = Date()
        let ageComponents = Calendar.current.dateComponents([.year], from: birthDate, to: now)
        return ageComponents.year ?? 0
    }

    var name: String {
        return "\(firstName) \(lastName)"
    }

    var heightText: String {
        return "\(height) cm"
    }

    var weightText: String {
        return "\(weight) kg"
    }
}
