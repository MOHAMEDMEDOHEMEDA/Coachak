//
//  TrainingPlanView.swift
//  Coashak
//
//  Created by Mohamed Magdy on 01/06/2025.
//

import SwiftUI


struct DailyScheduleView: View {
    @State private var selectedDay = "sunday"
    @State private var showingTraining = true
    let trainer: String
    let userId: String
    
    var body: some View {
        VStack(alignment: .leading) {
            HeaderView(title: showingTraining ? "Training Schedule" : "Meals Schedule")
            
            ToggleSection(showingTraining: $showingTraining)
            
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    if showingTraining {
                        UserTrainingPlanView(trainer: trainer, userID: userId)
                    } else {
                        ReadOnlyNutritionPlanView(trainer: trainer, userID: userId)
                    }
                }
                .padding()
            }
        }
        .background(Color.white)
    }
}

// MARK: - Toggle Switch
struct ToggleSection: View {
    @Binding var showingTraining: Bool
    
    var body: some View {
        HStack(spacing: 0) {
            Button(action: {
                showingTraining = true
            }) {
                Text("Training")
                    .fontWeight(.medium)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(showingTraining ? Color.colorPink.opacity(0.55) : Color.clear)
                    .foregroundStyle(Color.colorPurple)
                    .cornerRadius(10)
            }
            
            Button(action: {
                showingTraining = false
            }) {
                Text("Meals")
                    .fontWeight(.medium)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(!showingTraining ? Color.colorPink.opacity(0.55) : Color.clear)
                    .foregroundStyle(Color.colorPurple)
                    .cornerRadius(10)
            }
        }
        
        .background(Color.gray.opacity(0.1))
        .cornerRadius(12)
        .padding(.horizontal)
    }
}


// MARK: - Header
struct HeaderView: View {
    var title: String
    
    var body: some View {
        HStack {
            
            Spacer()
            Text(title)
                .font(.title2.bold())
            Spacer()
            
        }
        .padding()
        
    }
}



// MARK: - training plan view for client
struct UserTrainingPlanView: View {
    let trainer: String
    let userID: String
    @StateObject private var userProfileVM = UserProfileViewModel()
    @StateObject private var dayPlanVM = DayPlanViewModel()
    @State private var selectedDay = "sunday"

    var body: some View {
        VStack {
            HStack {
                Spacer()
                Text("My Training Plan")
                    .font(.title2)
                    .bold()
                Spacer()
            }
            .padding()

            headerSection

            DaysOfWeekPicker(selectedDay: $selectedDay)
                .padding(.vertical)

            if let dayPlan = dayPlanVM.dayPlan {
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        Text("\(dayPlan.day.capitalized) Training Plan")
                            .font(.title3)
                            .bold()

                        if let workout = dayPlan.workout {
                            WorkoutReadOnlyCard(workout: workout)
                        }
                        else {
                            Text("Select a day to view the meal plan.")
                                .foregroundColor(.gray)
                                .padding()
                        }
                    }
                    .padding(.horizontal)
                }
            } else if dayPlanVM.isLoading {
                ProgressView("Loading...")
            } else {
                Text("No training plan found.")
                    .foregroundColor(.gray)
                    .padding()
            }

            Spacer()
        }
        .task {
            userProfileVM.fetchUserProfile(userId: userID)
            await fetchDayPlan(for: selectedDay)
        }
        .onChange(of: selectedDay) { newDay in
            Task { await fetchDayPlan(for: newDay) }
        }
    }

    private func fetchDayPlan(for day: String) async {
        await dayPlanVM.fetchClientDayPlan(TrainerId: trainer, weekNumber: 1, dayName: day)
    }

    private var headerSection: some View {
        Group {
            if let trainee = userProfileVM.trainee {
                VStack(alignment: .leading, spacing: 12) {
                    HStack(spacing: 12) {
                        AsyncImageSafe(urlString: trainee.profilePhoto)
                            .frame(width: 50, height: 50)
                            .clipShape(Circle())

                        VStack(alignment: .leading) {
                            Text(trainee.name)
                                .font(.headline)
                            Text("Goal: \(trainee.fitnessGoal)")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }

                    HStack {
                        ProfileStat(title: "Age", value: "\(trainee.age)")
                        ProfileStat(title: "Height", value: trainee.heightText)
                        ProfileStat(title: "Weight", value: trainee.weightText)
                    }
                }
                .padding(.horizontal)
            } else {
                Text("Loading user data...")
                    .foregroundColor(.gray)
            }
        }
    }
}

struct WorkoutReadOnlyCard: View {
    let workout: Workout

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(workout.name.capitalized)
                .font(.title3)
                .fontWeight(.semibold)

            Divider()

            if workout.exercises.isEmpty {
                Text("No exercises yet.")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            } else {
                ForEach(workout.exercises) { exercise in
                    ExerciseCard(exercise: exercise)
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 3)
        )
    }
}


struct ReadOnlyNutritionPlanView: View {
    // Get client ID from UserDefaults
    let trainer: String
    let userID: String
    @StateObject private var userProfileVM = UserProfileViewModel()
    @StateObject private var dayPlanVM = DayPlanViewModel()
    @State private var selectedDay = "sunday"

    var body: some View {
        VStack {
            Text("Your Meal Plan")
                .font(.title2.bold())
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
                    }  else {
                        Text("Select a day to view the meal plan.")
                            .foregroundColor(.gray)
                            .padding()
                    }
                }
                .padding(.bottom)
            }
        }
        .task {
            userProfileVM.fetchUserProfile(userId: userID)
            await fetchDayPlan(for: selectedDay)
        }
        .onChange(of: selectedDay) { newDay in
            Task { await fetchDayPlan(for: newDay) }
        }
    }

    func fetchDayPlan(for day: String) async {
        await dayPlanVM.fetchClientDayPlan(TrainerId: trainer, weekNumber: 1, dayName: day)
    }

    private var headerSection: some View {
        Group {
            if let trainee = userProfileVM.trainee {
                VStack(alignment: .leading, spacing: 12) {
                    HStack(spacing: 12) {
                        AsyncImageSafe(urlString: trainee.profilePhoto)
                            .frame(width: 50, height: 50)
                            .clipShape(Circle())

                        VStack(alignment: .leading) {
                            Text(trainee.name)
                                .font(.headline)
                            Text("Goal: \(trainee.fitnessGoal)")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }

                    HStack {
                        ProfileStat(title: "Age", value: "\(trainee.age)")
                        ProfileStat(title: "Height", value: trainee.heightText)
                        ProfileStat(title: "Weight", value: trainee.weightText)
                    }
                }
                .padding(.horizontal)
            } else {
                Text("Loading user data...")
                    .foregroundColor(.gray)
            }
        }
    }
}




