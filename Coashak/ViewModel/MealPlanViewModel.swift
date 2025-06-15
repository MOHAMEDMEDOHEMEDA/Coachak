
//
//  MealPlanViewModel.swift
//  Coashak
//
//  Created by Mohamed Magdy on 01/06/2025.
//
//

import Foundation
import Combine

@MainActor // Ensure UI updates happen on the main thread
class MealPlanViewModel: ObservableObject {
    // MARK: - Form Inputs
    @Published var height = "175"
    @Published var weight = "70"
    @Published var age = "30"
    @Published var selectedGender: MealPlanFormView.Gender = .male
    @Published var workoutsPerWeek = 3
    @Published var selectedWeightGoal: MealPlanFormView.WeightGoal = .maintain
    @Published var allergies = ""
    @Published var includeIngredients = ""
    @Published var excludeIngredients = ""
    @Published var rotationAngle: Double = 0


    // MARK: - Main Meal Plan State Outputs
    @Published var isGeneratingMealPlan = false
    @Published var mealPlanGenerationComplete = false // Triggers navigation to MealPlanGeneratedView
    @Published var mealPlanErrorMessage: String?
    @Published var mealPlanResult: MealPlanResponse? // Stores the main meal plan
    @Published var mealPlanPollingStatusMessage: String?

    // MARK: - Similar Meals State Outputs (Updated)
    @Published var isFindingSimilarMeals = false
    @Published var similarMealsComplete = false // Triggers navigation to SimilarMealsView
    @Published var similarMealsErrorMessage: String?
    // Updated to store the full result item including similarity factors
    @Published var similarMealsResult: [SimilarMealResultItem]?
    @Published var similarMealsPollingStatusMessage: String?
    @Published var originalMealForSimilarity: MealAi? // Keep track of which meal we are finding similar ones for

    // MARK: - Task Management
    private var mealPlanGenerationTask: Task<Void, Never>?
    private var similarMealsTask: Task<Void, Never>?

    // MARK: - Deinitializer for cleanup
    deinit {
        // Directly cancel tasks. Avoid calling MainActor-isolated methods.
        mealPlanGenerationTask?.cancel()
        similarMealsTask?.cancel()
        print("MealPlanViewModel deinit: Tasks cancelled.")
    }

    // MARK: - Generate Main Meal Plan Function
        func generateMealPlan() {
            guard !isGeneratingMealPlan && !isFindingSimilarMeals else { return } // Prevent concurrent tasks

            // Reset main meal plan state
            isGeneratingMealPlan = true
            mealPlanGenerationComplete = false
            mealPlanErrorMessage = nil
            mealPlanResult = nil
            mealPlanPollingStatusMessage = "Initiating meal plan generation..."
            // Reset similar meal state as well
            resetSimilarMealState()

            guard let heightInt = Int(height), let weightInt = Int(weight), let ageInt = Int(age) else {
                mealPlanErrorMessage = "Please enter valid numeric values for height, weight, and age."
                isGeneratingMealPlan = false
                mealPlanPollingStatusMessage = nil
                return
            }

            let requestPayload = AIMealRequest(
                height_cm: heightInt, weight_kg: weightInt, age: ageInt,
                sex: selectedGender.rawValue.lowercased(), workouts_per_week: workoutsPerWeek,
                goal: selectedWeightGoal.rawValue.lowercased(),
                exclude_ingredients: excludeIngredients.split(separator: ",").map { String($0.trimmingCharacters(in: .whitespacesAndNewlines)) },
                allergies: allergies.split(separator: ",").map { String($0.trimmingCharacters(in: .whitespacesAndNewlines)) }
            )

            mealPlanGenerationTask = Task {
                do {
                    let initialResponse = try await NetworkManager.shared.requestMealPlanGeneration(payload: requestPayload)
                    let taskId = initialResponse.task_id
                    mealPlanPollingStatusMessage = "Generation started (Task ID: \(taskId)). Checking status..."
                    try await self.pollMealPlanTaskStatus(taskId: taskId)
                    if mealPlanResult != nil {
                        mealPlanGenerationComplete = true
                        mealPlanPollingStatusMessage = "Meal plan generated successfully!"
                    } else {
                        throw NSError(domain: "ViewModelError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Polling finished unexpectedly without result."])
                    }
                } catch {
                    self.mealPlanErrorMessage = error.localizedDescription
                    mealPlanPollingStatusMessage = "Generation failed."
                }
                self.isGeneratingMealPlan = false
            }
        }
    
    // MARK: - Find Similar Meals Function
    func findSimilarMeals(for meal: MealAi) {
        guard !isFindingSimilarMeals && !isGeneratingMealPlan else { return } // Prevent concurrent tasks

        // Reset similar meal state
        resetSimilarMealState()
        isFindingSimilarMeals = true
        originalMealForSimilarity = meal // Store the original meal
        similarMealsPollingStatusMessage = "Initiating similar meal search for \'\(meal.name)\'..."

        similarMealsTask = Task {
            do {
                // 1. Initiate Similar Meal Request
                let initialResponse = try await NetworkManager.shared.requestSimilarMealRecommendation(payload: meal)
                let taskId = initialResponse.task_id
                similarMealsPollingStatusMessage = "Similar meal search started (Task ID: \(taskId)). Checking status..."

                // 2. Start Polling for Similar Meals
                try await self.pollSimilarMealsTaskStatus(taskId: taskId)

                // 3. Handle Success (Check the updated similarMealsResult)
                if similarMealsResult != nil {
                    similarMealsComplete = true // Trigger navigation/sheet presentation
                    similarMealsPollingStatusMessage = "Similar meals found successfully!"
                } else {
                    throw NSError(domain: "ViewModelError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Similar meals polling finished unexpectedly without result."])
                }
            } catch {
                self.similarMealsErrorMessage = error.localizedDescription
                similarMealsPollingStatusMessage = "Finding similar meals failed."
            }
            self.isFindingSimilarMeals = false
        }
    }

    // MARK: - Polling Logic for Main Meal Plan
    private func pollMealPlanTaskStatus(taskId: String) async throws {
        let maxAttempts = 20
        let delaySeconds: UInt64 = 3

        for attempt in 1...maxAttempts {
            try Task.checkCancellation()
            do {
                let statusResponse = try await NetworkManager.shared.getTaskStatus(taskId: taskId)
                switch statusResponse.status.uppercased() {
                case "SUCCESS", "COMPLETED": // Handle "COMPLETED" as success too
                    if statusResponse.result != nil {
                        self.mealPlanResult = statusResponse
                        mealPlanPollingStatusMessage = "Task completed successfully."
                        return
                    } else {
                        mealPlanPollingStatusMessage = "Status: SUCCESS/COMPLETED but result not ready yet (Attempt \(attempt)/\(maxAttempts)). Waiting..."
                        try await Task.sleep(nanoseconds: delaySeconds * 1_000_000_000)
                    }
                case "PENDING", "STARTED", "RETRY", "PROCESSING": // Handle "PROCESSING"
                    mealPlanPollingStatusMessage = "Status: \(statusResponse.status) (Attempt \(attempt)/\(maxAttempts)). Waiting..."
                    try await Task.sleep(nanoseconds: delaySeconds * 1_000_000_000)
                case "FAILURE":
                    mealPlanPollingStatusMessage = "Task failed on server."
                    throw NSError(domain: "APIError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Meal plan generation failed on the server (Status: FAILURE)."])
                default:
                    mealPlanPollingStatusMessage = "Received unknown task status: \(statusResponse.status)"
                    throw NSError(domain: "APIError", code: 2, userInfo: [NSLocalizedDescriptionKey: "Received unknown task status: \(statusResponse.status)"])
                }
            } catch let pollingError as NSError where pollingError.domain == "APIError" && pollingError.code == 0 {
                 mealPlanPollingStatusMessage = "Status: PENDING/PROCESSING (Attempt \(attempt)/\(maxAttempts)). Waiting..."
                 try await Task.sleep(nanoseconds: delaySeconds * 1_000_000_000)
             } catch {
                 mealPlanPollingStatusMessage = "Error checking task status: \(error.localizedDescription)"
                 throw error
             }
        }
        mealPlanPollingStatusMessage = "Generation timed out after \(maxAttempts) attempts."
        throw NSError(domain: "ViewModelError", code: 3, userInfo: [NSLocalizedDescriptionKey: "Meal plan generation timed out."])
    }

    // MARK: - Polling Logic for Similar Meals (Updated)
    private func pollSimilarMealsTaskStatus(taskId: String) async throws {
        let maxAttempts = 20
        let delaySeconds: UInt64 = 3

        for attempt in 1...maxAttempts {
            try Task.checkCancellation()
            do {
                // Use the specific status checker for similar meals
                let statusResponse = try await NetworkManager.shared.getSimilarMealTaskStatus(taskId: taskId)
                
                // Use status from the outer SimilarMealResponse
                switch statusResponse.status.uppercased() {
                case "SUCCESS", "COMPLETED": // Handle "COMPLETED" as success
                    // Check if the result array is present (even if empty)
                    if statusResponse.result != nil {
                        // Assign the array of SimilarMealResultItem
                        self.similarMealsResult = statusResponse.result
                        similarMealsPollingStatusMessage = "Similar meals task completed successfully."
                        return // Exit polling loop
                    } else {
                        similarMealsPollingStatusMessage = "Status: SUCCESS/COMPLETED but similar meals result not ready yet (Attempt \(attempt)/\(maxAttempts)). Waiting..."
                        try await Task.sleep(nanoseconds: delaySeconds * 1_000_000_000)
                    }
                case "PENDING", "STARTED", "RETRY", "PROCESSING": // Handle "PROCESSING"
                    similarMealsPollingStatusMessage = "Similar meals status: \(statusResponse.status) (Attempt \(attempt)/\(maxAttempts)). Waiting..."
                    try await Task.sleep(nanoseconds: delaySeconds * 1_000_000_000)
                case "FAILURE":
                    similarMealsPollingStatusMessage = "Similar meals task failed on server."
                    throw NSError(domain: "APIError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Finding similar meals failed on the server (Status: FAILURE)."])
                default:
                    similarMealsPollingStatusMessage = "Received unknown similar meals task status: \(statusResponse.status)"
                    throw NSError(domain: "APIError", code: 2, userInfo: [NSLocalizedDescriptionKey: "Received unknown similar meals task status: \(statusResponse.status)"])
                }
            } catch let pollingError as NSError where pollingError.domain == "APIError" && pollingError.code == 0 {
                 // Specific case: getSimilarMealTaskStatus threw APIError code 0 (likely pending)
                 similarMealsPollingStatusMessage = "Similar meals status: PENDING/PROCESSING (Attempt \(attempt)/\(maxAttempts)). Waiting..."
                 try await Task.sleep(nanoseconds: delaySeconds * 1_000_000_000)
             } catch {
                 similarMealsPollingStatusMessage = "Error checking similar meals task status: \(error.localizedDescription)"
                 throw error // Re-throw to be caught by findSimilarMeals
             }
        }
        similarMealsPollingStatusMessage = "Finding similar meals timed out after \(maxAttempts) attempts."
        throw NSError(domain: "ViewModelError", code: 4, userInfo: [NSLocalizedDescriptionKey: "Finding similar meals timed out."])
    }

    // MARK: - Cancellation
    @MainActor func cancelMealPlanGeneration() {
        mealPlanGenerationTask?.cancel()
        isGeneratingMealPlan = false
        mealPlanPollingStatusMessage = "Generation cancelled."
        print("Meal plan generation task cancelled.")
    }

    @MainActor func cancelSimilarMealsSearch() {
        similarMealsTask?.cancel()
        isFindingSimilarMeals = false
        similarMealsPollingStatusMessage = "Similar meals search cancelled."
        print("Similar meals task cancelled.")
    }
    
    // MARK: - Reset State Helpers (Updated)
    func resetSimilarMealState() {
        // Call this before starting a new similar meal search or when leaving the view
        similarMealsTask?.cancel() // Cancel any ongoing similar meal task
        isFindingSimilarMeals = false
        similarMealsComplete = false
        similarMealsErrorMessage = nil
        similarMealsResult = nil // Reset the result array
        similarMealsPollingStatusMessage = nil
        originalMealForSimilarity = nil
    }
}



