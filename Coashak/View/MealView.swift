//
//  Meal.swift
//  Coashak
//
//  Created by Mohamed Magdy on 30/05/2025.
//


import SwiftUI

struct Meal: Identifiable, Codable {
    let id: UUID
    var name: String
    var mealType: String
    var isDone: Bool

    init(id: UUID = UUID(), name: String, mealType: String, isDone: Bool = false) {
        self.id = id
        self.name = name
        self.mealType = mealType
        self.isDone = isDone
    }
}

class MealsScheduleViewModel: ObservableObject {
    @Published var mealsByDate: [Date: [Meal]] = [:]

    func addMeal(on date: Date, meal: Meal) {
        let key = dateWithoutTime(date)
        if var existingMeals = mealsByDate[key] {
            existingMeals.append(meal)
            mealsByDate[key] = existingMeals
        } else {
            mealsByDate[key] = [meal]
        }
    }

    func toggleDone(for mealId: UUID, on date: Date) {
        let key = dateWithoutTime(date)
        if var meals = mealsByDate[key] {
            if let idx = meals.firstIndex(where: { $0.id == mealId }) {
                meals[idx].isDone.toggle()
                mealsByDate[key] = meals
            }
        }
    }

    func meals(for date: Date, type: String) -> [Meal] {
        let key = dateWithoutTime(date)
        return mealsByDate[key]?.filter { $0.mealType == type } ?? []
    }

    private func dateWithoutTime(_ date: Date) -> Date {
        let components = Calendar.current.dateComponents([.year, .month, .day], from: date)
        return Calendar.current.date(from: components)!
    }
}

struct RealMealsScheduleView: View {
    @StateObject private var viewModel = MealsScheduleViewModel()
    @State private var selectedDate = Date()

    @State private var newMealName: String = ""
    @State private var newMealType: String = "Breakfast"
    @State private var showAddMeal = false

    let mealTypes = ["Breakfast", "Snack", "Lunch", "Dinner"]

    var body: some View {
        NavigationView {
            VStack {
                // Date picker with formatted display
                DatePicker("Select Date", selection: $selectedDate, displayedComponents: .date)
                    .datePickerStyle(.compact)
                    .padding()

                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        ForEach(mealTypes, id: \.self) { type in
                            MealSectionView(
                                mealType: type,
                                meals: viewModel.meals(for: selectedDate, type: type),
                                toggleDone: { mealId in
                                    viewModel.toggleDone(for: mealId, on: selectedDate)
                                })
                        }
                    }
                    .padding(.horizontal)
                }

                Button(action: {
                    showAddMeal = true
                }) {
                    Text("Add Meal")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.purple)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding()
                }
            }
            .navigationTitle("Meals Schedule")
            .sheet(isPresented: $showAddMeal) {
                AddMealView(
                    mealTypes: mealTypes,
                    newMealName: $newMealName,
                    newMealType: $newMealType,
                    addAction: {
                        guard !newMealName.isEmpty else { return }
                        let meal = Meal(name: newMealName, mealType: newMealType)
                        viewModel.addMeal(on: selectedDate, meal: meal)
                        newMealName = ""
                        newMealType = "Breakfast"
                        showAddMeal = false
                    },
                    cancelAction: {
                        showAddMeal = false
                    })
            }
        }
    }
}

struct MealSectionView: View {
    let mealType: String
    var meals: [Meal]
    var toggleDone: (UUID) -> Void

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(mealType)
                    .font(.headline)
                mealTypeIcon(mealType)
            }
            if meals.isEmpty {
                Text("No items")
                    .foregroundColor(.gray)
                    .padding(.leading)
            } else {
                ForEach(meals) { meal in
                    HStack {
                        Text(meal.name)
                        Spacer()
                        Image(systemName: meal.isDone ? "checkmark.circle.fill" : "circle")
                            .foregroundColor(meal.isDone ? .green : .gray)
                            .onTapGesture {
                                toggleDone(meal.id)
                            }
                    }
                    .padding(.vertical, 4)
                }
            }
        }
    }

    func mealTypeIcon(_ type: String) -> Text {
        switch type {
        case "Breakfast": return Text("🍳")
        case "Snack": return Text("🍏")
        case "Lunch": return Text("🥗")
        case "Dinner": return Text("🍲")
        default: return Text("")
        }
    }
}

struct AddMealView: View {
    let mealTypes: [String]

    @Binding var newMealName: String
    @Binding var newMealType: String

    var addAction: () -> Void
    var cancelAction: () -> Void

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Meal Name")) {
                    TextField("e.g., Eggs", text: $newMealName)
                }
                Section(header: Text("Meal Type")) {
                    Picker("Meal Type", selection: $newMealType) {
                        ForEach(mealTypes, id: \.self) { type in
                            Text(type)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
            }
            .navigationBarTitle("Add Meal", displayMode: .inline)
            .navigationBarItems(leading: Button("Cancel", action: cancelAction),
                                trailing: Button("Add", action: addAction).disabled(newMealName.isEmpty))
        }
    }
}

struct RealMealsScheduleView_Previews: PreviewProvider {
    static var previews: some View {
        RealMealsScheduleView()
    }
}