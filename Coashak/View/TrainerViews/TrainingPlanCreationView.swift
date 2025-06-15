//
//  TrainingPlanView.swift
//  Coashak
//
//  Created by Mohamed Magdy on 03/06/2025.
//


import SwiftUI

struct TrainingPlanView: View {
    let id: String
    @StateObject private var userProfileVM = UserProfileViewModel()
    @StateObject private var dayPlanVM = DayPlanViewModel()
    @State private var selectedDay = "sunday"
    
    // Sheet state
    @State private var showingAddWorkoutSheet = false
    @State private var selectedWorkout: Workout?
    
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
                .padding()
            
            if let dayPlan = dayPlanVM.dayPlan {
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        Text("\(dayPlan.day.capitalized) Training Plan")
                            .font(.title3)
                            .bold()
                            .padding(.leading)
                        
                        if let workout = dayPlanVM.dayPlan?.workout {
                            WorkoutCardView(workout: workout,
                                            onAddExercise: {
                                selectedWorkout = workout
                            },
                                            onDeleteExercise: { exerciseId in
                                Task {
                                    await dayPlanVM.removeExercise(fromWorkout: workout.id, exerciseId: exerciseId)
                                    await fetchDayPlan(for: selectedDay) // Refresh after delete
                                }
                            })
                        } else {
                            Button(action: {
                                showingAddWorkoutSheet = true
                            }) {
                                HStack {
                                    Image(systemName: "plus.circle")
                                    Text("Add Workout")
                                }
                                .padding()
                                .background(Color.blue.opacity(0.1))
                                .cornerRadius(8)
                            }
                            .padding(.top)
                        }
                    }
                    .padding()
                }
            } else if dayPlanVM.isLoading {
                ProgressView("Loading...")
            } else if !dayPlanVM.errorMessage.isEmpty {
                Text(dayPlanVM.errorMessage)
                    .foregroundColor(.red)
            } else {
                Text("Select a day to load the training plan.")
                    .foregroundColor(.gray)
                    .padding()
            }
            
            Spacer()
        }
        .task {
            userProfileVM.fetchUserProfile(userId: id)
            await fetchDayPlan(for: selectedDay)
        }
        .onChange(of: selectedDay) { newDay in
            Task { await fetchDayPlan(for: newDay) }
        }
        .sheet(isPresented: $showingAddWorkoutSheet, onDismiss: {
            Task { await fetchDayPlan(for: selectedDay) }
        }) {
            if let dayId = dayPlanVM.dayPlan?.id {
                AddWorkoutSheet(dayId: dayId)
            }
        }
        .sheet(item: $selectedWorkout, onDismiss: {
            Task { await fetchDayPlan(for: selectedDay) }
        }) { workout in
            AddExerciseSheet(workoutId: workout.id)
        }
    }
    
    func fetchDayPlan(for day: String) async {
        await dayPlanVM.fetchDayPlan(clientId: id, weekNumber: 1, dayName: day)
    }
    
    var headerSection: some View {
        Group {
            if let trainee = userProfileVM.trainee {
                VStack(alignment: .leading, spacing: 12) {
                    HStack(alignment: .top, spacing: 12) {
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
                Text("No trainee data available")
                    .foregroundColor(.gray)
                    .padding()
            }
        }
    }
}


struct WorkoutCardView: View {
    let workout: Workout
    let onAddExercise: () -> Void
    let onDeleteExercise: (String) -> Void
    
    @State private var showDeleteAlert = false
    @State private var exerciseToDelete: String?

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Workout Title
            HStack {
                Text(workout.name.capitalized)
                    .font(.title3)
                    .fontWeight(.semibold)
                
                Spacer()
                
                Button(action: onAddExercise) {
                    Image(systemName: "plus.circle.fill")
                        .font(.title2)
                        .foregroundColor(.colorPurple)
                }
                .buttonStyle(PlainButtonStyle())
            }

            Divider()

            if workout.exercises.isEmpty {
                Text("No exercises yet.")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            } else {
                ForEach(workout.exercises) { exercise in
                    HStack {
                        ExerciseCard(exercise: exercise)
                        Spacer()
                        Button(action: {
                            exerciseToDelete = exercise.id
                            showDeleteAlert = true
                        }) {
                            Image(systemName: "trash")
                                .foregroundColor(.red)
                        }
                        .buttonStyle(BorderlessButtonStyle())
                    }
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemBackground))
                .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 3)
        )
        .alert(isPresented: $showDeleteAlert) {
            Alert(
                title: Text("Delete Exercise"),
                message: Text("Are you sure you want to delete this exercise?"),
                primaryButton: .destructive(Text("Delete")) {
                    if let id = exerciseToDelete {
                        onDeleteExercise(id)
                    }
                },
                secondaryButton: .cancel()
            )
        }
    }
}




// MARK: - AddWorkoutSheet

struct AddWorkoutSheet: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = AddWorkoutViewModel()
    let dayId: String
    
    @State private var workoutName = ""
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Workout Name", text: $workoutName)
            }
            .navigationTitle("New Workout")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        Task {
                            await viewModel.addWorkout(toDayPlanId: dayId, name: workoutName)
                            dismiss() // sheet will close; TrainingPlanView will refresh onDismiss
                        }
                    }
                    .disabled(workoutName.isEmpty)
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
            }
        }
        .presentationDetents([.medium])
    }
}

// MARK: - AddExerciseSheet

import SwiftUI

struct AddExerciseSheet: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = AddExerciseViewModel()
    let workoutId: String
    
    @State private var name = ""
    @State private var sets = ""
    @State private var reps = ""
    @State private var rest = ""
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Exercise Name", text: $name)
                TextField("Sets", text: $sets)
                    .keyboardType(.numberPad)
                TextField("Reps", text: $reps)
                    .keyboardType(.numberPad)
                TextField("Rest (sec)", text: $rest)
                    .keyboardType(.numberPad)
            }
            .navigationTitle("New Exercise")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        if let setsInt = Int(sets),
                           let repsInt = Int(reps),
                           let restInt = Int(rest) {
                            
                            // Use new ExerciseDetail for request
                            let exerciseDetail = ExerciseDetail(id: UUID().uuidString, name: name)
                            
                            Task {
                                await viewModel.addExercise(
                                    toWorkoutId: workoutId,
                                    exercise: exerciseDetail,
                                    sets: setsInt,
                                    reps: repsInt,
                                    rest: restInt,
                                    sortOrder: 0 // Optional - depends if your API uses it or ignores it
                                )
                                dismiss() // Close the sheet
                            }
                        }
                    }
                    .disabled(name.isEmpty || Int(sets) == nil || Int(reps) == nil || Int(rest) == nil)
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
        .presentationDetents([.medium])
    }
}


struct ExerciseCard: View {
    let exercise: ExerciseWrapper
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(exercise.exercise.name.capitalized)
                .font(.headline)
                .fontWeight(.medium)
            
            HStack {
                Label("\(exercise.sets) Sets", systemImage: "repeat")
                Label("\(exercise.reps) Reps", systemImage: "number")
                Label("\(exercise.rest) sec", systemImage: "timer")
            }
            .font(.caption)
            .foregroundColor(.secondary)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.colorPink)
        )
    }
}


