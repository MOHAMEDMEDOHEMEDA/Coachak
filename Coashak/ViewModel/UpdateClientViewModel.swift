//
//  UpdateClientViewModel.swift
//  Coashak
//
//  Created by Mohamed Magdy on 30/05/2025.
//


import Foundation
import UIKit

@MainActor
class UpdateClientViewModel: ObservableObject {
    @Published var profileImage: UIImage? = nil
    @Published var weight: Int = 0
    @Published var goalWeight: Int = 0
    @Published var height: Int = 0
    @Published var age: Int = 0
    @Published var job: String = ""
    @Published var gender: String = ""
    @Published var fitnessLevel: FitnessLevel = .beginner
    @Published var fitnessGoal: String = FitnessGoal.loseWeight.rawValue
    @Published var healthConditions: [String] = []
    @Published var allergies: [String] = []

    @Published var isLoading: Bool = false
    @Published var updateSuccess: Bool = false
    @Published var errorMessage: String?
    @Published var navigateToHomePage: Bool = false

    func updateClient() async {
        isLoading = true
        errorMessage = nil
        updateSuccess = false

        do {
            var imageUrl: String? = nil
            if let profilePic = profileImage {
                imageUrl = try await NetworkManager.shared.uploadImages(profilePicture: profilePic)
                print("✅ Image uploaded: \(imageUrl ?? "nil")")
            }

            let client = Client(
                gender: gender,
                profilePic: imageUrl ?? "",
                weight: weight,
                height: height,
                fitnessLevel: fitnessLevel.rawValue,
                fitnessGoal: fitnessGoal, goalweight: goalWeight,
                healthCondition: healthConditions,
                allergy: allergies
            )

            let encoder = JSONEncoder()
            encoder.keyEncodingStrategy = .convertToSnakeCase
            let encodedData = try encoder.encode(client)
            let jsonString = String(data: encodedData, encoding: .utf8) ?? "–failed to stringify–"
            print("▶️ Payload JSON:\n\(jsonString)")

            try await NetworkManager.shared.updateUser(client)
            print("✅ updateUser returned without throwing")

            updateSuccess = true
            navigateToHomePage = true
        } catch {
            errorMessage = error.localizedDescription
            print("❌ updateClient failed: \(error.localizedDescription)")
            updateSuccess = false
        }

        isLoading = false
    }
}

import Foundation

enum FitnessLevel: String, Codable, CaseIterable, Identifiable {
    case beginner
    case intermediate
    case advanced

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .beginner: return "Beginner"
        case .intermediate: return "Intermediate"
        case .advanced: return "Advanced"
        }
    }

    init?(displayName: String) {
        switch displayName.lowercased() {
        case "beginner": self = .beginner
        case "intermediate": self = .intermediate
        case "advanced": self = .advanced
        default: return nil
        }
    }
}
enum FitnessGoal: String, CaseIterable, Identifiable {
    case loseWeight, gainMuscles, weightLifting, diet

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .loseWeight: return "Lose Weight"
        case .gainMuscles: return "Gain Muscles"
        case .weightLifting: return "Weight Lifting"
        case .diet: return "Diet"
        }
    }

    var imageName: String {
        switch self {
        case .loseWeight: return "Image1"
        case .gainMuscles: return "Image2"
        case .weightLifting: return "Image3"
        case .diet: return "Image4"
        }
    }
}


