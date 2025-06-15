//
//  MealPlanGeneratedView.swift
//  Coashak
//
//  Created by Mohamed Magdy on 01/06/2025.
//  Modified by Mohamed Magdy on 02/06/2025 for ViewModel integration.
//

import SwiftUI

// MARK: - Main View for Displaying Generated Meal Plan

struct MealPlanGeneratedView: View {
    // Observe the ViewModel passed from the form view
    @ObservedObject var viewModel: MealPlanViewModel

    // State to track the selected day within this view
    @State private var selectedDayId: Int = 1 // Default to the first day
    @State private var isAnimating = false


    // Placeholder for navigation action
    @Environment(\.dismiss) var dismiss

    // Computed property to get the meal plan for the selected day from the ViewModel
    private var selectedDailyPlan: DayPlan? {
        viewModel.mealPlanResult?.result?.recommendation.days.first { $0.day == selectedDayId }
    }
    
    // Computed property for the overall daily nutritional recommendations
    private var dailyNutritionRecommendation: NutritionInfo? {
        viewModel.mealPlanResult?.result?.recommendation.dailyNutrition
    }

    var body: some View {
        // Use a specific Navigation title if needed, or rely on the one set by the form view
        // NavigationView { // Remove NavigationView if this view is pushed onto an existing stack
        ZStack {
            ScrollView {
                if let resultData = viewModel.mealPlanResult?.result {
                    VStack(alignment: .leading, spacing: 20) {
                        // Day Selector using the actual days from the response
                        DaySelectorViewIntegrated(selectedDayId: $selectedDayId, days: resultData.recommendation.days)
                        
                        // Daily Nutritional Summary (Using overall recommendation for now)
                        // TODO: Clarify if summary should be per-day or overall recommendation
                        if let nutritionRec = dailyNutritionRecommendation {
                            DailySummaryViewIntegrated(summary: nutritionRec)
                        }
                        
                        // Display meals for the selected day
                        if let plan = selectedDailyPlan {
                            MealSectionViewIntegrated(viewModel: viewModel, title: "Breakfast", meals: plan.meals.filter { $0.type.lowercased() == "breakfast" })
                            MealSectionViewIntegrated(viewModel: viewModel, title: "Lunch", meals: plan.meals.filter { $0.type.lowercased() == "lunch" })
                            MealSectionViewIntegrated(viewModel: viewModel, title: "Snack", meals: plan.meals.filter { $0.type.lowercased() == "snack" })
                            MealSectionViewIntegrated(viewModel: viewModel, title: "Dinner", meals: plan.meals.filter { $0.type.lowercased() == "dinner" })
                        } else {
                            Text("No meal plan details available for Day \(selectedDayId).")
                                .padding()
                        }
                    }
                    .padding(.vertical)
                } else {
                    // Show loading or error state if result is not available (though navigation should prevent this)
                    VStack {
                        Text("Loading meal plan...")
                        if let error = viewModel.mealPlanPollingStatusMessage {
                            Text("Error: \(error)")
                                .foregroundColor(.red)
                        }
                    }
                    .padding()
                }


            }
            .navigationTitle("Your Meal Plan") // Title for this specific view
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(isPresented: $viewModel.similarMealsComplete) {
                SimilarMealsView(viewModel: viewModel)
            }
            .navigationBarBackButtonHidden(true) // Hide default back button if needed
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    // Custom back button if needed, or rely on NavigationStack
                    Button { dismiss() } label: {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.primary)
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button { /* Add Export Action */ } label: {
                        HStack {
                            Image(systemName: "square.and.arrow.up") // Export icon
                            Text("Export")
                        }
                        .font(.subheadline)
                        .foregroundColor(.purple) // Use consistent color
                    }
                }
            }
            // Subtitle (Consider passing week range dynamically)
            .safeAreaInset(edge: .top) {
                Text("Week of May 1 - May 7") // Make dynamic if needed
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    .padding(.bottom, -10)
                    .background(Color(UIColor.systemBackground)) // Match background
            }
            .navigationBarBackButtonHidden(true)
            if viewModel.isFindingSimilarMeals {
                ZStack {
                    // 1. Blurred background
                    VisualEffectBlur(blurStyle: .systemUltraThinMaterialDark)
                        .ignoresSafeArea()
                    
                    // 2. Centered loading animation + message
                    VStack(spacing: 24) {
                        // Simple animated loading using rotation
                        ZStack {
                            Circle()
                                .stroke(Color.colorPurple.opacity(0.2), lineWidth: 8)
                                .frame(width: 80, height: 80)

                            Circle()
                                .trim(from: 0, to: 0.75)
                                .stroke(Color.colorPurple, style: StrokeStyle(lineWidth: 8, lineCap: .round))
                                .frame(width: 80, height: 80)
                                .rotationEffect(.degrees(isAnimating ? 360 : 0))
                                .animation(.linear(duration: 1).repeatForever(autoreverses: false), value: isAnimating)
                        }
                        .onAppear {
                            isAnimating = true
                        }
                        
                        // Catchy message
                        Text("✨ Just a moment! We're cooking up your Similar meal plan... 🍽️")
                            .font(.body.weight(.semibold))
                            .foregroundColor(.colorPurple)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color(.systemBackground).opacity(0.95))
                            .shadow(color: Color.colorPurple.opacity(0.3), radius: 10, x: 0, y: 5)
                    )
                    .padding(.horizontal, 30)
                }
                .onDisappear{
                    isAnimating = false
                }
            }
        }
        // } // End of NavigationView if used
        // .navigationViewStyle(.stack) // Not needed with NavigationStack
    }
        
}

// MARK: - Helper Views (Adapted for MealPlanResponse data)

// Horizontal Day Selector (Integrated)
struct DaySelectorViewIntegrated: View {
    @Binding var selectedDayId: Int
    let days: [DayPlan] // Use DayPlan from MealPlanResponse

    // Helper to get short day name (e.g., "Sun") from day number (1-7)
    private func dayName(from dayNumber: Int) -> String {
        let formatter = DateFormatter()
        // Assuming day 1 = Sunday, day 7 = Saturday
        // Adjust if API uses a different convention (e.g., 1 = Monday)
        return formatter.shortWeekdaySymbols[ (dayNumber - 1) % 7 ]
    }

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(days, id: \.day) { day in
                    DayButtonIntegrated(dayName: dayName(from: day.day ?? 0), dateNumber: day.day ?? 0, dayId: day.day ?? 0, selectedDayId: $selectedDayId)
                }
            }
            .padding(.horizontal)
        }
    }
}

struct DayButtonIntegrated: View {
    let dayName: String
    let dateNumber: Int // Using day number as date number for simplicity
    let dayId: Int
    @Binding var selectedDayId: Int

    var isSelected: Bool {
        dayId == selectedDayId
    }

    var body: some View {
        Button(action: { selectedDayId = dayId }) {
            VStack {
                Text(dayName)
                    .font(.caption)
                    .fontWeight(isSelected ? .bold : .regular)
                Text("\(dateNumber)")
                    .font(.headline)
                    .fontWeight(isSelected ? .bold : .regular)
            }
            .frame(width: 60, height: 60)
            .foregroundColor(isSelected ? .white : .primary)
            .background(isSelected ? Color.colorPurple.opacity(0.8) : Color.gray.opacity(0.15))
            .cornerRadius(10)
        }
    }
}

// Daily Nutritional Summary Section (Integrated)
struct DailySummaryViewIntegrated: View {
    let summary: NutritionInfo // Use NutritionInfo from MealPlanResponse
    let columns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]

    // Helper to create NutrientCardInfo from NutritionInfo
    private var nutrientCards: [NutrientCardInfo] {
        var cards: [NutrientCardInfo] = []
        if let bmi = summary.BMI { // BMI is optional
            cards.append(NutrientCardInfo(name: "BMI", value: String(format: "%.2f", bmi), progress: calculateProgress(value: bmi, maxValue: 30))) // Example max
        }
        cards.append(NutrientCardInfo(name: "Calories", value: "\(summary.calories)", progress: calculateProgress(value: Double(summary.calories), maxValue: 3500))) // Example max
        cards.append(NutrientCardInfo(name: "Protein", value: "\(summary.proteinG)g", progress: calculateProgress(value: Double(summary.proteinG), maxValue: 200))) // Example max
        cards.append(NutrientCardInfo(name: "Fats", value: "\(summary.fatsG)g", progress: calculateProgress(value: Double(summary.fatsG), maxValue: 100))) // Example max
        cards.append(NutrientCardInfo(name: "Carbs", value: "\(summary.carbsG)g", progress: calculateProgress(value: Double(summary.carbsG), maxValue: 500))) // Example max
        return cards
    }
    
    // Placeholder progress calculation (replace with actual logic/targets)
    private func calculateProgress(value: Double?, maxValue: Double) -> Double {
        guard let value = value, maxValue > 0 else { return 0 }
        return min(max(value / maxValue, 0.0), 1.0) // Clamp between 0 and 1
    }

    var body: some View {
        VStack(alignment: .leading) {
            Text("Daily Nutritional Summary") // Or "Recommendations"
                .font(.headline)
                .padding(.horizontal)

            LazyVGrid(columns: columns, spacing: 15) {
                ForEach(nutrientCards) { nutrient in
                    NutrientCardIntegrated(nutrient: nutrient)
                }
            }
            .padding()
            .background(Color.colorPink.opacity(0.4)) // Use consistent color
            .cornerRadius(12)
            .padding(.horizontal)
        }
    }
}

// Intermediate struct for Nutrient Card display data
struct NutrientCardInfo: Identifiable {
    let id = UUID()
    let name: String
    let value: String
    let progress: Double
}

// Nutrient Card for the Summary Grid (Integrated)
struct NutrientCardIntegrated: View {
    let nutrient: NutrientCardInfo

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(nutrient.name)
                .font(.caption)
                .foregroundColor(.secondary)
            Text(nutrient.value)
                .font(.headline)
                .fontWeight(.medium)
            ProgressView(value: nutrient.progress)
                .tint(.colorPurple.opacity(0.8)) // Use consistent color
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(UIColor.systemBackground))
        .cornerRadius(8)
        .shadow(color: .gray.opacity(0.1), radius: 3, x: 0, y: 2)
    }
}

// Reusable Meal Section (Integrated)
struct MealSectionViewIntegrated: View {
    @ObservedObject var viewModel: MealPlanViewModel
    let title: String
    let meals: [MealAi] // Use Meal from MealPlanResponse

    var body: some View {
        // Only show section if there are meals for it
        if !meals.isEmpty {
            VStack(alignment: .leading, spacing: 10) {
                Text(title)
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.horizontal)

                ForEach(meals, id: \.name) { meal in // Assuming name is unique per section
                    MealCardViewIntegrated(viewModel: viewModel, meal: meal)
                        .padding(.horizontal)
                }
            }
        }
    }
}

// Card View for a Single Meal (Integrated)
struct MealCardViewIntegrated: View {
    @ObservedObject var viewModel: MealPlanViewModel
    let meal: MealAi // Use Meal from MealPlanResponse

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(meal.name)
                    .font(.headline)
                    .lineLimit(2)
                Spacer()
                // Navigation Link to Meal Detail View (Pass meal data)
                NavigationLink {
                    MealDetailsView(meal: meal)
//                    Text("Meal Detail for \(meal.name)") // Placeholder
                } label: {
                    Circle()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [.colorPink, .colorPurple]), // Use consistent colors
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: 24, height: 24)
                        .overlay(
                            Image(systemName: "chevron.right")
                                .foregroundColor(.white)
                                .font(.caption.weight(.bold))
                        )
                }
            }

            HStack {
                Image(systemName: "clock")
                // Duration is not in the Meal model from AiMealPlanResponse.swift
                // Text("\(meal.duration) mins") // Remove or get from elsewhere
                Text(meal.type) // Display meal type instead?
                
                Spacer()
                
                Button {
                    viewModel.findSimilarMeals(for: meal, )
                } label: {
                    HStack(spacing: 4) {
                        Image(systemName: "shuffle") // Example icon
                            .font(.callout)
                        Text("Similar Meal")
                            .font(.caption)
                            .fontWeight(.medium)
                    }
                    .padding(.vertical, 6)
                    .padding(.horizontal, 10)
                    .foregroundColor(.colorPurple) // Use consistent color
                    .overlay(Capsule().stroke(Color.colorPurple.opacity(0.5), lineWidth: 1))
                }
            }
            .font(.caption)
            .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(UIColor.systemBackground))
        .cornerRadius(12)
        .shadow(color: .gray.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}

// MARK: - Preview
struct MealPlanGeneratedView_Previews: PreviewProvider {
    static var previews: some View {
        // Create a mock ViewModel with sample data for preview
        let mockViewModel = MealPlanViewModel()
        // Populate mockViewModel.mealPlanResult with sample MealPlanResponse data here
        // For simplicity, showing empty state or basic structure
        MealPlanGeneratedView(viewModel: mockViewModel)
    }
}

