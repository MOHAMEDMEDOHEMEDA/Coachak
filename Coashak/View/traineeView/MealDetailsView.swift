//
//  MealDetailsView.swift
//  Coashak
//
//  Created by Mohamed Magdy on 02/06/2025.
//

import SwiftUI

struct MealDetailsView: View {
    let meal: MealAi
    @Environment(\.dismiss) var dismiss

    private var preparationSteps: [String] {
        guard let preparation = meal.preparation else {
            return []
        }

        let pattern = #"(?=\d+\.\s)"#
        guard let regex = try? NSRegularExpression(pattern: pattern) else {
            return [preparation]  // fallback to whole string if regex fails
        }

        let nsString = preparation as NSString
        let matches = regex.matches(in: preparation, range: NSRange(location: 0, length: nsString.length))

        var results: [String] = []

        for (i, match) in matches.enumerated() {
            let start = match.range.location
            let end = (i + 1 < matches.count) ? matches[i + 1].range.location : nsString.length
            let range = NSRange(location: start, length: end - start)
            let step = nsString.substring(with: range).trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            results.append(step)
        }

        return results
    }


    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {

                // MARK: - Header Section
                VStack(alignment: .leading, spacing: 8) {
                    Text(meal.name)
                        .font(.title2)
                        .fontWeight(.bold)

                    HStack(spacing: 16) {
                        Label("15 mins", systemImage: "clock")
                        Label("1 Serving", systemImage: "person")
                    }
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                }
                .padding(.horizontal)

                // MARK: - Nutrition Facts Section
                if let nutrition = meal.nutrition {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Nutrition Facts")
                            .font(.headline)
                            .padding(.horizontal)

                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 12) {
                                NutritionFactCard(iconName: "flame.fill", iconColor: .orange, label: "Calories", value: "\(nutrition.calories)", unit: "Kcal")
                                NutritionFactCard(iconName: "atom", iconColor: .purple, label: "Proteins", value: "\(nutrition.proteinG)", unit: "g")
                                NutritionFactCard(iconName: "squareshape.split.2x2.dotted", iconColor: .blue, label: "Carbs", value: "\(nutrition.carbsG)", unit: "g")
                                NutritionFactCard(iconName: "drop.fill", iconColor: .yellow, label: "Fats", value: "\(nutrition.fatsG)", unit: "g")
                            }
                            .padding(.horizontal)
                        }
                    }
                }

                // MARK: - Ingredients Section
                VStack(alignment: .leading, spacing: 12) {
                    Text("Ingredients")
                        .font(.headline)
                        .padding(.horizontal)

                    if let ingredients = meal.ingredients, !ingredients.isEmpty {
                        VStack(alignment: .leading, spacing: 10) {
                            ForEach(ingredients, id: \.self) { ingredient in
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(ingredient)
                                    if ingredient != ingredients.last {
                                        Divider().padding(.leading)
                                    }
                                }
                                .padding(.vertical, 4)
                            }
                        }
                        .padding()
                        .background(Color.colorPurple.opacity(0.2))
                        .cornerRadius(12)
                        .padding(.horizontal)
                    } else {
                        Text("No ingredients available.")
                            .foregroundColor(.secondary)
                            .padding(.horizontal)
                    }
                }

                // MARK: - Cooking Process Section
                VStack(alignment: .leading, spacing: 12) {
                    Text("Cooking Process")
                        .font(.headline)
                        .padding(.horizontal)

                    if preparationSteps.isEmpty {
                        Text("No preparation steps provided.")
                            .foregroundColor(.secondary)
                            .padding(.horizontal)
                    } else {
                        VStack(alignment: .leading, spacing: 15) {
                            ForEach(Array(preparationSteps.enumerated()), id: \.offset) { index, step in
                                HStack(alignment: .top, spacing: 12) {
                                    Text("\(index + 1)")
                                        .font(.caption.weight(.bold))
                                        .foregroundColor(.white)
                                        .frame(width: 24, height: 24)
                                        .background(Circle().fill(Color.colorPink.opacity(0.8)))

                                    Text(step)
                                        .font(.body)
                                }
                            }
                        }
                        .padding()
                        .background(Color.pink.opacity(0.1))
                        .cornerRadius(12)
                        .padding(.horizontal)
                    }
                }

            }
            .padding(.vertical)
        }
        .navigationTitle("Meal Details")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button { dismiss() } label: {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.primary)
                }
            }
        }
    }
}

// MARK: - NutritionFactCard

struct NutritionFactCard: View {
    let iconName: String
    let iconColor: Color
    let label: String
    let value: String
    let unit: String

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: iconName)
                .font(.title2)
                .foregroundColor(iconColor)
                .frame(width: 40, height: 40)
                .background(iconColor.opacity(0.15))
                .clipShape(Circle())

            Text(label)
                .font(.caption)
                .foregroundColor(.secondary)

            HStack(alignment: .firstTextBaseline, spacing: 2) {
                Text(value)
                    .font(.headline)
                    .fontWeight(.medium)
                Text(unit)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .frame(width: 100)
        .background(Color(UIColor.systemBackground))
        .cornerRadius(12)
        .shadow(color: .gray.opacity(0.1), radius: 3, x: 0, y: 2)
    }
}

// MARK: - Preview

struct MealDetailsView_Previews: PreviewProvider {
    static var sampleMeal = MealAi(
        name: "Ful Medames With Boiled Eggs and Whole Wheat Pita",
        type: "Breakfast",
        ingredients: [
            "Ful Medames (cooked)",
            "3 Large Boiled Eggs",
            "2 Whole Wheat Pita Bread",
            "1 tbsp Olive Oil",
            "1 tbsp Lemon Juice",
            "Chopped Tomato",
            "Chopped Onion",
            "1 tbsp Cumin",
            "Salt to taste",
            "Pepper to taste"
        ],
        preparation: "1. Warm Ful Medames in a saucepan.\n2. Mash some of the Ful slightly.\n3. Stir in olive oil, lemon juice, cumin, salt, and pepper.\n4. Serve topped with chopped tomato and onion.\n5. Serve with boiled eggs and warm pita bread.",
        nutrition: NutritionInfo(BMI: nil, calories: 641, proteinG: 36, fatsG: 21, carbsG: 81),
        imageURL: ""
    )

    static var previews: some View {
        NavigationView {
            MealDetailsView(meal: sampleMeal)
        }
    }
}
