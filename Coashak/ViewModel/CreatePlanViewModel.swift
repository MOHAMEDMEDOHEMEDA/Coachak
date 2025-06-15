//
//  CreatePlanViewModel.swift
//  Coashak
//
//  Created by Mohamed Magdy on 11/06/2025.
//

import Foundation

import Foundation
import SwiftUI

@MainActor
class CreatePlanViewModel: ObservableObject {
    @Published var plans: [PlanForResponse] = []

    // Input fields
    @Published var title: String = ""
    @Published var description: String = ""
    @Published var price: String = ""
    @Published var durationInWeeks: String = ""
    @Published var hasNutritionPlan: Bool? = false
    @Published var hasTrainingPlan: Bool = false
    
    // UI feedback
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var successMessage: String?

    func savePlan() async {
        guard let priceInt = Int(price), let durationInt = Int(durationInWeeks), let hasNutrition = hasNutritionPlan else {
            errorMessage = "Please complete all fields correctly."
            return
        }

        isLoading = true
        errorMessage = nil
        successMessage = nil

        let plan = Plan(
            title: title,
            description: description,
            price: priceInt,
            durationInWeeks: durationInt,
            hasNutritionPlan: hasNutrition,
            hasTrainingPlan: hasTrainingPlan
        )

        do {
            let response = try await NetworkManager.shared.addPlan(plan)
            successMessage = "Plan created successfully: \(response.plan.title)"
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }
    // MARK: - Fetch Plans
    func fetchPlans() async {
        isLoading = true
        errorMessage = nil

        do {
            let fetchedPlans = try await NetworkManager.shared.getPlans()
            self.plans = fetchedPlans.plan
        } catch {
            self.errorMessage = "Failed to load plans: \(error.localizedDescription)"
            print("❌ Plan fetch error: \(error)")
        }

        isLoading = false
    }
}
