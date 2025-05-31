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
    // MARK: - Input Properties (you can bind these to a form in SwiftUI)
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var phoneNumber: String = ""
    @Published var profileImage: UIImage? = nil
    @Published var weight: Int = 0
    @Published var weightGoal: Int = 0
    @Published var height: Int = 0
    @Published var age: Int = 0
    @Published var job: String = ""
    @Published var fitnessLevel: String = ""
    @Published var fitnessGoal: String = ""
    @Published var healthConditions: [String] = []
    @Published var allergies: [String] = []
    
    // MARK: - Output
    @Published var isLoading: Bool = false
    @Published var updateSuccess: Bool = false
    @Published var errorMessage: String?
    @Published var navigateToHomePage: Bool = false
    
    
    // MARK: - Update Function
    func updateClient() async {
        isLoading = true
        errorMessage = nil
        updateSuccess = false
        
        do {
            var imageUrl: String? = nil
            if let profilePic = profileImage {
                imageUrl = try await NetworkManager.shared.uploadImages(profilePicture: profilePic)
            }
            
            // Create the Client model with the uploaded image URL if available
            let client = Client(
                firstName: firstName,
                lastName: lastName,
                phoneNumber: phoneNumber,
                profilePic: imageUrl ?? "",
                weight: weight,
                weightGoal: weightGoal,
                height: height,
                job: job,
                fitnessLevel: fitnessLevel,
                fitnessGoal: fitnessGoal,
                healthCondition: healthConditions,
                allergy: allergies,
            )
            
            try await NetworkManager.shared.updateUser(client)
            updateSuccess = true
            navigateToHomePage = true
        } catch {
            errorMessage = error.localizedDescription
            updateSuccess = false
        }
        
        isLoading = false
    }
}
