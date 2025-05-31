//
//  TrainerProfile.swift
//  Coashak
//
//  Created by Mohamed Magdy on 11/05/2025.
//

import Foundation

// MARK: - Data Models (Placeholders - replace with your actual data models)
struct TrainerProfile: Identifiable {
    var id = UUID()
    let name: String
    let bio: String
    let email: String
    let experienceYears: Int
    let certifications: [String]
    let availability: String
    let rating: Double
    let reviews: [Review]
    let profileImageName: String // Placeholder for image name
}

struct Review: Identifiable {
    let id = UUID()
    let reviewerName: String
    let rating: Int
    let comment: String
}
