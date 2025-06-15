//
//  NutritionPlanView.swift
//  Coashak
//
//  Created by Mohamed Magdy on 03/06/2025.
//


import SwiftUI

struct NutritionPlanView: View {
    let id: String
    @StateObject private var userProfileVM = UserProfileViewModel()
    @StateObject private var dayPlanVM = DayPlanViewModel()
    @State private var selectedDay = "sunday"
    @State private var showingAddMealSheet = false

    var body: some View {
        VStack {
            HStack {
                Spacer()
                Text("Create Training Plan")
                    .font(.title2)
                    .bold()
                Spacer()
            }
            .padding()

            headerSection

            DaysOfWeekPicker(selectedDay: $selectedDay)
                .padding(.top)

            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    if let dayPlan = dayPlanVM.dayPlan {
                        Text("\(dayPlan.day.capitalized) Meals")
                            .font(.title2.bold())
                            .padding(.bottom, 5)

                        let groupedMeals = Dictionary(grouping: dayPlan.meals ?? []) { $0.type }

                        ForEach(["breakfast", "lunch", "snack", "dinner"], id: \.self) { type in
                            if let mealsForType = groupedMeals[type], !mealsForType.isEmpty {
                                VStack(alignment: .leading, spacing: 10) {
                                    Text(type.capitalized)
                                        .font(.headline)
                                        .padding(.horizontal)

                                    ForEach(mealsForType, id: \.id) { meal in
                                        MealCardView(meal: meal)
                                    }
                                }
                                .padding()
                                .background(Color(.systemGray6))
                                .cornerRadius(12)
                                .padding(.horizontal)
                            }
                        }
                    } else if dayPlanVM.isLoading {
                        ProgressView("Loading...")
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding()
                    } else if !dayPlanVM.errorMessage.isEmpty {
                        Text(dayPlanVM.errorMessage)
                            .foregroundColor(.red)
                            .padding()
                    } else {
                        Text("Select a day to view the meal plan.")
                            .foregroundColor(.gray)
                            .padding()
                    }
                }
                .padding(.bottom, 80) // Space for the button
            }

            // Add Meal Button outside ScrollView
            Button(action: { showingAddMealSheet = true }) {
                Label("Add Meal", systemImage: "plus.circle.fill")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.colorLightPink)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                    .padding(.horizontal)
            }
            .padding(.bottom)
        }
        .task {
            userProfileVM.fetchUserProfile(userId: id)
            await fetchDayPlan(for: selectedDay)
        }
        .onChange(of: selectedDay) { newDay in
            Task { await fetchDayPlan(for: newDay) }
        }
        .sheet(isPresented: $showingAddMealSheet) {
            if let dayId = dayPlanVM.dayPlan?.id {
                AddMealSheet(dayId: dayId) {
                    Task { await fetchDayPlan(for: selectedDay) }
                }
                .presentationDetents([.medium])
            }
        }
    }

    func fetchDayPlan(for day: String) async {
        await dayPlanVM.fetchDayPlan(clientId: id, weekNumber: 1, dayName: day)
    }

    var headerSection: some View {
        Group {
            if let trainee = userProfileVM.trainee {
                HStack(spacing: 12) {
                    AsyncImageSafe(urlString: trainee.profilePhoto)
                        .frame(width: 60, height: 60)
                        .clipShape(Circle())

                    VStack(alignment: .leading, spacing: 4) {
                        Text(trainee.name)
                            .font(.title3.bold())
                        Text("Goal: \(trainee.fitnessGoal)")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    Spacer()
                }
                .padding()
            } else {
                ProgressView("Loading profile...")
            }
        }
    }
}

struct MealCardView: View {
    let meal: MealEntry

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(meal.meal.name.capitalized)
                    .font(.headline)
                Text(meal.type.capitalized)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            Spacer()
            Image(systemName: "fork.knife")
                .foregroundColor(.pink)
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 12).fill(Color(.systemBackground).shadow(.drop(radius: 1))))
    }
}




struct AddMealSheet: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var mealVM = MealViewModel()
    
    let dayId: String
    let onComplete: () -> Void
    
    @State private var mealName = ""
    @State private var mealType = "breakfast"

    let mealTypes = ["breakfast", "lunch", "snack", "dinner"]

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Meal Details")) {
                    TextField("Meal Name", text: $mealName)

                    Picker("Meal Type", selection: $mealType) {
                        ForEach(mealTypes, id: \.self) {
                            Text($0.capitalized)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
            }
            .navigationTitle("New Meal")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        Task {
                            await mealVM.addMeal(mealName: mealName, mealType: mealType, to: dayId)
                            dismiss()
                            onComplete()
                        }
                    }
                    .disabled(mealName.isEmpty)
                }
            }
        }
        .presentationDetents([.medium])
    }
}



struct ProfileStat: View {
    let title: String
    let value: String

    var body: some View {
        VStack {
            Text(value)
                .font(.subheadline)
                .fontWeight(.semibold)
            Text(title)
                .font(.caption)
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity)
    }
}

struct DaysOfWeekPicker: View {
    @Binding var selectedDay: String
    let daysOfWeek = ["sunday", "monday", "tuesday", "wednesday", "thursday", "friday", "saturday"]

    var body: some View {
        ScrollViewReader { proxy in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(daysOfWeek, id: \.self) { day in
                        DayCard(day: day, isSelected: selectedDay == day) {
                            selectedDay = day // Single selection
                        }
                        .id(day)
                    }
                }
                .padding(.horizontal)
            }
            .onChange(of: selectedDay) { day in
                withAnimation {
                    proxy.scrollTo(day, anchor: .center)
                }
            }
            .onAppear {
                if !selectedDay.isEmpty {
                    proxy.scrollTo(selectedDay, anchor: .center)
                }
            }
        }
    }
}


struct DayCard: View {
    let day: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Text(day)
            .fontWeight(.medium)
            .foregroundColor(isSelected ? .white : .black)
            .padding(.vertical, 10)
            .padding(.horizontal, 20)
            .background(isSelected ? Color.pink : Color.gray.opacity(0.2))
            .cornerRadius(10)
            .onTapGesture {
                action()
            }
            .animation(.easeInOut(duration: 0.2), value: isSelected)
    }
}



