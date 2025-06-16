//
//  EditTrainerProfileView.swift
//  Coashak
//
//  Created by Mohamed Magdy on 10/06/2025.
//


import SwiftUI

struct EditTrainerProfileView: View {
    @ObservedObject var viewModel: TrainerProfileViewModel
    @ObservedObject var certVM: CertificateViewModel
    @StateObject private var updateVM = UpdateTrainerViewModel()
    
    @State var firstName: String = ""
    @State var lastName: String = ""
    @State var gender: String = ""
    @State var email: String = ""
    @State var bio: String = ""
    @State var yearsOfExperience: Int = 0
    @State var pricePerSession: String = ""
    @State var birthday: Date = Date()
    @State var availableDays: [String] = []
    @State private var selectedImage: UIImage? = nil
    @State private var showCertificateSheet = false
    @State private var tempCertificateName = ""
    @State private var tempOrganization = ""
    @State private var isShowingImagePicker = false
    @State private var showPhotoSourceSelection = false
    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary

    var body: some View {
        VStack(spacing: 0) {
            profileImageSection
                .padding(.top, 20)
            ScrollView{
                VStack(spacing: 0) {
                    EditableRow(title: "First Name", value: $firstName)
                    EditableRow(title: "Last Name", value: $lastName)
                    EditableRow(title: "bio", value: $bio)
                    EditableRow(title: "Gender", value: $gender)
                    DatePicker("Birthday", selection: $birthday, displayedComponents: .date)
                    EditableRow(title: "Email", value: $email)
                    EditableRow(title: "Years of Experience", value: Binding(
                        get: { String(yearsOfExperience) },
                        set: { updateVM.yearsOfExperience = Int($0) ?? 0 }
                    ))
                    EditableRow(title: "Price Per Session", value: $pricePerSession)
                    
                    AvailabilitySelector(selectedDays: $availableDays)
                    CertificatesSection(certVM: certVM, showCertificateSheet: $showCertificateSheet)
                        .onChange(of: showCertificateSheet) { isShowing in
                            if !isShowing {
                                // Reset error when sheet dismisses
                                certVM.errorMessage = nil
                            }
                        }
                    
                    //                profileItem(title: "Areas of Expertise", value: viewModel.areasOfExpertise.joined(separator: ", "))
                }
                .padding(.top)
                .padding(.horizontal)
            }
         

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
                        .cornerRadius(12)
                }
            }
            .padding(.top, 24)
            .padding(.bottom, 16)
            .disabled(updateVM.isLoading)
        }
        .background(Color(.systemGray6).ignoresSafeArea())
        .navigationTitle("Edit Trainer Profile")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            guard let trainer = viewModel.trainer else { return }

            firstName = trainer.firstName
            lastName = trainer.lastName
            gender = trainer.gender ?? ""
            email = trainer.email
            bio = trainer.bio ?? ""
            yearsOfExperience = trainer.yearsOfExperience ?? 0
            birthday = trainer.dateOfBirth
            availableDays = trainer.availableDays
            print("👤 Loaded Trainer for editing: \(trainer.firstName), DOB: \(trainer.dateOfBirth)")

        }
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
            ImagePicker(selectedImage: $selectedImage, sourceType: sourceType, allowsEditing: false)
        }
        .sheet(isPresented: $showCertificateSheet) {
            CertificateSheetView(
                tempCertificateName: $tempCertificateName,
                tempOrganization: $tempOrganization,
                showCertificateSheet: $showCertificateSheet,
                certVM: certVM
            )
        }
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

    // MARK: - Save Profile Logic
    private func saveProfile() async {
        updateVM.profileImage = selectedImage
        updateVM.firstName = firstName
        updateVM.lastName = lastName
        updateVM.email = email
        updateVM.gender = gender
        updateVM.bio = bio
        updateVM.birthday = birthday
        updateVM.availableDays = availableDays
        
        await updateVM.updateTrainer(useFullProfile: true )
    }

    // MARK: - Profile Image Section
    private var profileImageSection: some View {
        VStack {
            if let selectedImage = selectedImage {
                Image(uiImage: selectedImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 150, height: 150)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.gray.opacity(0.3), lineWidth: 2))
                    .shadow(radius: 5)
            } else {
                ZStack(alignment: .bottomTrailing) {
                    Circle()
                        .fill(Color.gray.opacity(0.2))
                        .frame(width: 150, height: 150)
                    Image(systemName: "pencil")
                        .padding(8)
                        .background(Color.white)
                        .clipShape(Circle())
                        .shadow(radius: 2)
                        .offset(x: -10, y: -10)
                }
            }

            Button("Edit") {
                showPhotoSourceSelection = true
            }
            .foregroundColor(.colorPurple)
            .fontWeight(.medium)
        }
    }

    // MARK: - Helpers
    private func profileItem(title: String, value: String) -> some View {
        HStack {
            Text(title)
                .fontWeight(.semibold)
            Spacer()
            Text(value)
                .foregroundColor(.gray)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .padding(.horizontal)
    }

    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}

struct AvailabilitySelector: View {
    @Binding var selectedDays: [String]
    
    private let daysOfWeek = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Availability")
                .font(.headline)
                .padding(.horizontal)

            LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 3), spacing: 12) {
                ForEach(daysOfWeek, id: \.self) { day in
                    DayToggleButton(day: day, isSelected: selectedDays.contains(day)) {
                        if let index = selectedDays.firstIndex(of: day) {
                            selectedDays.remove(at: index)
                        } else {
                            selectedDays.append(day)
                        }
                    }
                }
            }
            .padding(.horizontal)
        }
        .padding(.vertical, 8)
    }
}

struct DayToggleButton: View {
    let day: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(day)
                .padding(.vertical, 8)
                .padding(.horizontal, 16)
                .frame(maxWidth: .infinity)
                .background(isSelected ? Color.colorMidPink : Color.clear)
                .foregroundColor(isSelected ? .white : .black)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.colorMidPink, lineWidth: 1)
                )
                .clipShape(Capsule())
        }
    }
}

