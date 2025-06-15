//
//  SimilarMealsView.swift
//  Coashak
//
//  Created by Mohamed Magdy on 03/06/2025.
//


import SwiftUI

struct SimilarMealsView: View {
    @ObservedObject var viewModel: MealPlanViewModel
    @Environment(\.dismiss) var dismiss

    var body: some View {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Display the original meal name if available
                    if let originalMeal = viewModel.originalMealForSimilarity {
                        Text("Similar Meals for \"\(originalMeal.name)\"")
                            .font(.title2).bold()
                            .padding(.horizontal)
                    }

                    // Handle Loading State
                    if viewModel.isFindingSimilarMeals {
                        VStack {
                            ProgressView()
                            Text(viewModel.similarMealsPollingStatusMessage ?? "Finding similar meals...")
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .padding(.top, 5)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                    // Handle Error State
                    } else if let errorMessage = viewModel.similarMealsErrorMessage {
                        Text("Error: \(errorMessage)")
                            .foregroundColor(.red)
                            .padding()
                    // Handle Success State (with results)
                    } else if let similarMealItems = viewModel.similarMealsResult {
                        if similarMealItems.isEmpty {
                            Text("No similar meals found.")
                                .foregroundColor(.secondary)
                                .padding()
                        } else {
                            // Iterate over SimilarMealResultItem
                            ForEach(similarMealItems) { item in
                                SimilarMealItemView(item: item)
                                    .padding(.horizontal)
                            }
                        }
                    // Handle Empty/Initial State (should ideally not be reached if logic is correct)
                    } else {
                        Text("No similar meal data available.")
                            .foregroundColor(.secondary)
                            .padding()
                    }
                }
                .padding(.vertical)
            }
            .navigationTitle("Similar Meals")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true) // Hide default back button if needed
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    // Custom back button if needed, or rely on NavigationStack
                    Button { dismiss() } label: {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.primary)
                    }
                }
            }
         
            // Reset state when the view disappears (optional, depends on desired flow)
            // .onDisappear {
            //     viewModel.resetSimilarMealState()
            // }
        
       
    }
}

// MARK: - View for a Single Similar Meal Item

struct SimilarMealItemView: View {
    let item: SimilarMealResultItem

    var meal: MealAi {
        MealAi(
            name: item.name,
            type: item.type,
            ingredients: item.ingredients,
            preparation: item.preparation,
            nutrition: item.nutrition,
            imageURL: nil // Use nil or a placeholder if backend doesn’t send image_url
        )
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            MealCardViewForSimilar(meal: meal)

            VStack(alignment: .leading, spacing: 5) {
                Text("Why it's similar:")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.secondary)

                ForEach(item.similarityFactors, id: \.self) { factor in
                    HStack(alignment: .top) {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.colorPurple)
                            .font(.caption)
                            .padding(.top, 2)
                        Text(factor)
                            .font(.caption)
                    }
                }
            }
            .padding(.leading, 5)
        }
        .padding(.bottom)
    }
}


// MARK: - Adapted Meal Card for Similar View (No Similar Button)

// Create a variation of MealCardViewIntegrated specifically for this view
// to avoid recursion or unwanted buttons.
struct MealCardViewForSimilar: View {
    let meal: MealAi

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(meal.name)
                    .font(.headline)
                    .lineLimit(2)
                Spacer()
                NavigationLink {
                    MealDetailsView(meal: meal)
                } label: {
                    Circle()
                        .fill(LinearGradient(gradient: Gradient(colors: [.colorPink, .colorPurple]), startPoint: .leading, endPoint: .trailing))
                        .frame(width: 24, height: 24)
                        .overlay(Image(systemName: "chevron.right").foregroundColor(.white).font(.caption.weight(.bold)))
                }
            }
            HStack {
                Image(systemName: "clock")
                Text(meal.type)
                Spacer()
            }
            .font(.caption)
            .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(UIColor.systemBackground))
        .cornerRadius(12)
        .shadow(color: .gray.opacity(0.8), radius: 4, x: 0, y: 2)
    }
}


// MARK: - Preview
struct SimilarMealsView_Previews: PreviewProvider {
    static var previews: some View {
        let mockViewModel = createMockViewModel()
        
        return SimilarMealsView(viewModel: mockViewModel)
    }

    static func createMockViewModel() -> MealPlanViewModel {
        let viewModel = MealPlanViewModel()

        
        let originalMeal = MealAi(
            name: "Ful Medames",
            type: "breakfast",
            ingredients: [],
            preparation: nil,
            nutrition: nil,
            imageURL: nil
        )

        // Assign values
        viewModel.originalMealForSimilarity = originalMeal
        viewModel.similarMealsResult = [
            SimilarMealResultItem(
                name: "Egyptian Scrambled Eggs",
                type: "breakfast",
                ingredients: ["Eggs", "Veggies"],
                preparation: "Scramble",
                nutrition: NutritionInfo(BMI: nil, calories: 280, proteinG: 12, fatsG: 12, carbsG: 28),
                similarityFactors: ["Similar protein content.", "Comparable carbs.", "Uses common Egyptian flavors."]
            ),
            SimilarMealResultItem(
                name: "Tamia (Falafel)",
                type: "breakfast",
                ingredients: ["Fava beans", "Tahini"],
                preparation: "Fry",
                nutrition: NutritionInfo(BMI: nil, calories: 320, proteinG: 11, fatsG: 12, carbsG: 33),
                similarityFactors: ["Fava bean base provides similar protein.", "Pita bread offers similar carbs.", "Also a staple of Egyptian cuisine."]
            )
        ]


        // You can also simulate loading or error by uncommenting:
        // viewModel.isFindingSimilarMeals = true
        // viewModel.similarMealsErrorMessage = "Failed to load."

        return viewModel
    }
}

// Assuming MealDetailsView exists
// struct MealDetailsView: View { ... }

