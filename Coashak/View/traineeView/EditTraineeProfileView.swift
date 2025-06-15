//
//  EditTraineeProfileView.swift
//  Coashak
//
//  Created by Mohamed Magdy on 22/12/2024.
//

import SwiftUI

struct EditTraineeProfileView: View {
    @ObservedObject var viewModel: ClientProfileViewModel
    @StateObject private var updateVM = UpdateClientViewModel()  // 1. Add update VM

    @State private var name: String = ""
    @State private var gender: String = ""
    @State private var birthday: Date = Date()
    @State private var email: String = ""
    @State private var height: String = ""
    @State private var weight: String = ""
    @State private var goal: Int = 0
    @State private var fitnessLevel: String = ""

    @State private var selectedImage: UIImage? = nil
    @State private var isShowingImagePicker = false
    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @State private var showPhotoSourceSelection = false

    var body: some View {
        VStack(spacing: 0) {
            profileImageSection
                .frame(height: UIScreen.main.bounds.height / 4)

            Form {
                Section(header: Text("Personal Information")) {
                    EditableRow(title: "Name", value: $name)
                    EditableRow(title: "Gender", value: $gender)
                    DatePicker("Birthday", selection: $birthday, displayedComponents: .date)
                        .datePickerStyle(.compact)
                    EditableRow(title: "Email", value: $email)
                    EditableRow(title: "Height", value: $height)
                    EditableRow(title: "Weight", value: $weight)
                    EditableRow(title: "Goal", value: Binding(
                        get: { String(goal) },
                        set: { goal = Int($0) ?? 0 }
                    ))
                    EditableRow(title: "Fitness Level", value: $fitnessLevel)
                }
            }
            .padding(.top, 20)

            // 2. Save button with async action
            Button(action: {
                Task {
                    await saveProfile()
                }
            }) {
                if updateVM.isLoading {
                    ProgressView()
                        .frame(width: 143, height: 40)
                } else {
                    Text("Save")
                        .font(.system(size: 20))
                        .foregroundColor(.white)
                        .frame(width: 143, height: 40)
                        .background(Color.colorPurple)
                        .cornerRadius(8)
                }
            }
            .padding()
            .disabled(updateVM.isLoading)
            .alert(isPresented: Binding<Bool>(
                get: { updateVM.errorMessage != nil || updateVM.updateSuccess },
                set: { _ in
                    if updateVM.updateSuccess {
                        updateVM.updateSuccess = false
                    }
                    updateVM.errorMessage = nil
                }
            )) {
                if let errorMessage = updateVM.errorMessage {
                    return Alert(title: Text("Error"), message: Text(errorMessage), dismissButton: .default(Text("OK")))
                } else {
                    return Alert(title: Text("Success"), message: Text("Profile updated successfully!"), dismissButton: .default(Text("OK")))
                }
            }
        }
        .background(Color.gray.opacity(0.1))
        .navigationTitle("Edit Profile")
        .confirmationDialog("Choose Photo Source", isPresented: $showPhotoSourceSelection) {
            Button("Camera") {
                sourceType = .camera
                isShowingImagePicker = true
            }
            Button("Photo Library") {
                sourceType = .photoLibrary
                isShowingImagePicker = true
            }
            Button("Cancel", role: .cancel) {}
        }
        .sheet(isPresented: $isShowingImagePicker) {
            ImagePicker(
                selectedImage: $selectedImage,
                sourceType: sourceType,
                allowsEditing: false
            )
        }
        .onAppear {
            if let user = viewModel.client {
                name = "\(user.firstName) \(user.lastName)"
                birthday = user.dateOfBirth
                email = user.email
                height = user.height.map { "\($0)" } ?? ""
                weight = user.weight.map { "\($0)" } ?? ""
                goal = user.weightGoal ?? 0
                fitnessLevel = user.fitnessLevel ?? ""
                selectedImage = nil
            }
        }
    }

    // MARK: - Save Profile Logic
    private func saveProfile() async {
        // Map your view fields to updateVM properties
        updateVM.profileImage = selectedImage
        updateVM.height = Int(height) ?? 0
        updateVM.weight = Int(weight) ?? 0
        updateVM.gender = String(gender)

        // Calculate age from birthday
        updateVM.age = Calendar.current.dateComponents([.year], from: birthday, to: Date()).year ?? 0
        // Use fitnessLevel enum if possible, else fallback to beginner
        updateVM.fitnessLevel = FitnessLevel(displayName: fitnessLevel) ?? .beginner
        // For demo, let's assign a goal string (you can expand this)
        updateVM.fitnessGoal = FitnessGoal.loseWeight.rawValue // or map your goal accordingly
        updateVM.goalWeight = Int(goal)

        // Clear arrays or add your own logic
        updateVM.healthConditions = []
        updateVM.allergies = []

        await updateVM.updateClient()
    }

    // MARK: - Date Formatter
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }

    // MARK: - Profile Image Section
    private var profileImageSection: some View {
        VStack {
            if let selectedImage = selectedImage {
                Image(uiImage: selectedImage)
                    .resizable()
                    .scaledToFit()
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.gray.opacity(0.3), lineWidth: 2))
                    .shadow(radius: 5)
            } else {
                Image(systemName: "person.crop.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .foregroundStyle(Color.colorPink)
                    .clipShape(Circle())
                    .shadow(radius: 5)
            }
            Button("Edit") {
                showPhotoSourceSelection = true
            }
            .foregroundColor(.colorPurple)
            .fontWeight(.medium)
        }
        .frame(maxWidth: .infinity)
    }
}


struct EditableRow: View {
    let title: String
    @Binding var value: String

    var body: some View {
        HStack {
            Text(title)
                .fontWeight(.medium)
                .frame(width: 120, alignment: .leading)
            Spacer()
            TextField(title, text: $value)
                .multilineTextAlignment(.trailing)
            
        }
        .padding(.vertical, 24)
    }
}
