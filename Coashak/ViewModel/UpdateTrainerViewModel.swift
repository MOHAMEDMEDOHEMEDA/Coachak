//
//  UpdateClientViewModel 2.swift
//  Coashak
//
//  Created by Mohamed Magdy on 09/06/2025.
//

// MARK: - ViewModel
import Foundation
import SwiftUI


@MainActor
class UpdateTrainerViewModel: ObservableObject {
    @Published var profileImage: UIImage? = nil
    @Published var bio: String = ""
    @Published var availableDays: [String] = []
    @Published var pricePerSession: String = ""
    @Published var yearsOfExperience: Int = 0
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var gender: String = ""
    @Published var email: String = ""
    @Published var birthday: Date = Date()

    @Published var isLoading: Bool = false
    @Published var updateSuccess: Bool = false
    @Published var errorMessage: String?
    @Published var navigateToHomePage: Bool = false

    func updateTrainer(useFullProfile: Bool = false) async {
        isLoading = true
        errorMessage = nil
        updateSuccess = false

        do {
            var imageUrl: String? = nil
            if let profilePic = profileImage {
                imageUrl = try await NetworkManager.shared.uploadImages(profilePicture: profilePic)
                print("✅ Image uploaded: \(imageUrl ?? "nil")")
            }

            if useFullProfile {
                let trainer = Trainer(
                    profilePic: imageUrl ?? "",
                    bio: bio,
                    availableDays: availableDays,
                    pricePerSession: Int(pricePerSession) ?? 0,
                    yearsOfExperience: yearsOfExperience,
                    firstName: firstName,
                    lastName: lastName,
                    gender: gender,
                    email: email,
                    birthday: birthday
                )

                try await NetworkManager.shared.updateTrainer(trainer)
            } else {
                let trainer = TrainerForUpdate(
                    profilePic: imageUrl ?? "",
                    bio: bio,
                    availableDays: availableDays,
                    pricePerSession: Int(pricePerSession) ?? 0,
                    yearsOfExperience: yearsOfExperience
                )

                try await NetworkManager.shared.updateTrainer(trainer)
            }

            print("✅ updateTrainer returned without throwing")
            updateSuccess = true
            navigateToHomePage = true
        } catch {
            errorMessage = error.localizedDescription
            print("❌ updateTrainer failed: \(error.localizedDescription)")
            updateSuccess = false
        }

        isLoading = false
    }
}
