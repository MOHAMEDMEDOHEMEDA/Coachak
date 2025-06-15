//
//  MealPlanFormView.swift
//  Coashak
//
//  Created by Mohamed Magdy on 01/06/2025.
//  Modified by Mohamed Magdy on 02/06/2025 for ViewModel integration.
//

import SwiftUI
import UIKit

// Main View for the Meal Plan Form
struct MealPlanFormView: View {
    // Use @StateObject to own the ViewModel instance for this view lifecycle
    @StateObject var viewModel = MealPlanViewModel()

    // Placeholder for navigation action
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack {
            ZStack {
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {

                        Text("Personalized Meal Plan")
                            .font(.title).fontWeight(.bold)

                        // Personal Details Section
                        SectionHeader(title: "Personal Details")
                        HStack(spacing: 16) {
                            FormField(title: "Height (cm)", text: $viewModel.height)
                                .keyboardType(.numberPad)
                            FormField(title: "Weight (kg)", text: $viewModel.weight)
                                .keyboardType(.numberPad)
                        }
                        HStack(spacing: 16) {
                            FormField(title: "Age", text: $viewModel.age)
                                .keyboardType(.numberPad)
                            VStack(alignment: .leading) {
                                Text("Gender").font(.caption).foregroundColor(.gray)
                                Menu {
                                    ForEach(MealPlanFormView.Gender.allCases) { gender in
                                        Button {
                                            viewModel.selectedGender = gender
                                        } label: {
                                            Text(gender.rawValue)
                                        }
                                    }
                                } label: {
                                    FormPickerLabel(text: viewModel.selectedGender.rawValue)
                                }
                            }
                        }

                        // Fitness Goals Section
                        SectionHeader(title: "Fitness Goals")
                        VStack(alignment: .leading) {
                            Text("Workouts per Week").font(.caption).foregroundColor(.gray)
                            Menu {
                                ForEach(1...7, id: \.self) { count in
                                    Button {
                                        viewModel.workoutsPerWeek = count
                                    } label: {
                                        Text("\(count) workout\(count > 1 ? "s" : "")")
                                    }
                                }
                            } label: {
                                FormPickerLabel(text: "\(viewModel.workoutsPerWeek) workout\(viewModel.workoutsPerWeek > 1 ? "s" : "")")
                            }
                            .frame(maxWidth: .infinity)
                        }

                        VStack(alignment: .leading) {
                            Text("Weight Goal").font(.caption).foregroundColor(.gray)
                            HStack(spacing: 12) {
                                ForEach(MealPlanFormView.WeightGoal.allCases) { goal in
                                    WeightGoalButton(goal: goal, selectedGoal: $viewModel.selectedWeightGoal)
                                }
                            }
                            .frame(maxWidth: .infinity)
                        }

                        // Dietary Preferences Section
                        SectionHeader(title: "Dietary Preferences")
                        FormField(title: "Allergies (comma-separated)", placeholder: "e.g. peanuts, shellfish", text: $viewModel.allergies)
                        HStack(alignment: .top, spacing: 8) {
                            Image(systemName: "info")
                                .font(.system(size: 16))
                                .foregroundColor(.white)
                                .padding(6)
                                .background(Color.colorPurple)
                                .clipShape(Circle())

                            Text("Your meal plan will be created using ONLY these ingredients.")
                                .font(.system(size: 14))
                                .foregroundColor(.black)
                        }
                        .padding()
                        .background(.lightPurble)
                        .cornerRadius(12)
                        FormField(title: "Include Ingredients (comma-separated)", placeholder: "e.g. chicken, corn, broccoli", text: $viewModel.includeIngredients)
                        HStack(alignment: .top, spacing: 8) {
                            Image(systemName: "info")
                                .font(.system(size: 16))
                                .foregroundColor(.white)
                                .padding(6)
                                .background(Color.colorCards)
                                .clipShape(Circle())

                            Text("These ingredients will NOT appear in any of your meals.")
                                .font(.system(size: 14))
                                .foregroundColor(.black)
                        }
                        .padding()
                        .background(.colorPink.opacity(0.4))
                        .cornerRadius(12)
                        FormField(title: "Exclude Ingredients (comma-separated)", placeholder: "e.g. pork, nuts, mushrooms", text: $viewModel.excludeIngredients)

                        Spacer(minLength: 20)

                        // Generate Button & Status Display
                        if !viewModel.isGeneratingMealPlan {
                            Button(action: { viewModel.generateMealPlan() }) {
                                Text("Generate Meal Plan")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.colorPurple)
                                    .cornerRadius(10)
                            }
                        }

//                        if let errorMessage = viewModel.mealPlanPollingStatusMessage {
//                            Text("Error: \(errorMessage)")
//                                .font(.footnote)
//                                .foregroundColor(.red)
//                                .frame(maxWidth: .infinity, alignment: .center)
//                        }
                    }
                    .padding(.bottom,100)
                    .padding()
                }

                if viewModel.isGeneratingMealPlan {
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
                                    .rotationEffect(.degrees(viewModel.rotationAngle))
                                    .animation(.linear(duration: 1).repeatForever(autoreverses: false), value: viewModel.rotationAngle)
                            }
                            .onAppear {
                                viewModel.rotationAngle = 360
                            }

                            // Catchy message
                            Text("✨ Just a moment! We're cooking up your personalized meal plan... 🍽️")
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
                }

            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button { dismiss() } label: {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.primary)
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {} label: {
                        Image(systemName: "fork.knife") // Placeholder icon
                            .foregroundColor(.colorPink) // Placeholder color
                    }
                }
            }
            // Navigation Destination triggered by ViewModel state
            .navigationDestination(isPresented: $viewModel.mealPlanGenerationComplete) {
                MealPlanGeneratedView(viewModel: viewModel)
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

// MARK: - Helper Views

struct FormPickerLabel: View {
    let text: String
    var body: some View {
        HStack {
            Text(text)
                .foregroundColor(.colorPurple)
            Spacer()
            Image(systemName: "chevron.down")
                .foregroundColor(.gray)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.gray.opacity(0.5))
        )
    }
}

struct SectionHeader: View {
    let title: String
    var body: some View {
        Text(title)
            .font(.title2)
            .fontWeight(.bold)
    }
}

struct FormField: View {
    let title: String
    var placeholder: String = ""
    @Binding var text: String
    var footer: String? = nil

    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.caption)
                .foregroundColor(.gray)
            TextField(placeholder, text: $text)
                .padding(10)
                .background(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.5)))
            if let footer = footer {
                Text(footer)
                    .font(.caption2)
                    .foregroundColor(.gray)
            }
        }
    }
}

struct WeightGoalButton: View {
    let goal: MealPlanFormView.WeightGoal
    @Binding var selectedGoal: MealPlanFormView.WeightGoal

    var isSelected: Bool {
        goal == selectedGoal
    }

    var body: some View {
        Button(action: { selectedGoal = goal }) {
            VStack(spacing: 8) {
                Image(goal.imageName)
                    .font(.title2)
                    .foregroundColor(isSelected ? .purple : .gray)
                Text(goal.rawValue)
                    .font(.caption)
                    .fontWeight(isSelected ? .bold : .regular)
                    .foregroundColor(isSelected ? .colorPurple : .primary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(isSelected ? Color.colorPurple.opacity(0.15) : Color.clear)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(isSelected ? Color.purple : Color.gray.opacity(0.5), lineWidth: 1.5)
            )
        }
    }
}

struct VisualEffectBlur: UIViewRepresentable {
    var blurStyle: UIBlurEffect.Style

    func makeUIView(context: Context) -> UIVisualEffectView {
        return UIVisualEffectView(effect: UIBlurEffect(style: blurStyle))
    }

    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {}
}


extension MealPlanFormView {
    enum Gender: String, CaseIterable, Identifiable {
        case male = "Male"
        case female = "Female"
        var id: String { self.rawValue }
    }

    enum WeightGoal: String, CaseIterable, Identifiable {
        case lose = "Lose"
        case maintain = "Maintain"
        case gain = "Gain"
        var id: String { self.rawValue }

        var imageName: String {
            switch self {
            case .lose: return "lose"
            case .maintain: return "maintain"
            case .gain: return "weight_gain_icon"
            }
        }
    }
}

// MARK: - Preview
struct MealPlanFormView_Previews: PreviewProvider {
    static var previews: some View {
        MealPlanFormView()
    }
}
