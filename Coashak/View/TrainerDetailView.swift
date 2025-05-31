//
//  TrainerDetailView.swift
//  Coashak
//
//  Created by Mohamed Magdy on 15/12/2024.
//

import SwiftUI
import PhotosUI
import AVFoundation

struct TrainerDetailView: View {
    @State private var bio: String = ""
    @State private var certificateName: String = ""
    @State private var certificateFile: String = ""
    @State private var optionalURL: String = ""
    @State private var expiryDate = Date()
    @State private var selectedExperience = ""
    @State private var selectedExpertise = ""
    @State private var availabilityDate = Date()
    @State private var navigateToAuth = false
    @State private var profileImage: UIImage? = nil
    @State private var showImagePicker = false
    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @State private var cameraGranted: Bool = false
    @State private var photoLibraryGranted: Bool = false
    @State private var showSourceTypeDialog = false

    let yearsOfExperienceOptions = ["1-2 Years", "3-5 Years", "5+ Years"]
    let areasOfExpertiseOptions = ["Fitness", "Nutrition", "Yoga", "Strength Training"]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Create Trainer Profile")
                        .font(.title2)
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.top)

                    // Profile Image Upload Section
                    VStack {
                        ZStack {
                            Circle()
                                .fill(Color.gray.opacity(0.2))
                                .frame(width: 160, height: 160)

                            if let image = profileImage {
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 160, height: 160)
                                    .clipShape(Circle())
                            } else {
                                Image(systemName: "photo")
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundColor(.gray)
                                    .frame(width: 40, height: 40)
                            }
                        }

                        Button(action: {
                            requestPermissionsAndShowPicker()
                        }) {
                            Text("Upload")
                                .foregroundColor(.white)
                                .frame(width: 120, height: 36)
                                .background(Color.colorMidPink)
                                .cornerRadius(8)
                        }
                        .padding(.top, 8)
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.bottom, 8)

                    Divider()

                    Group {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Bio").font(.headline)
                            TextField("Type here....", text: $bio).formFieldStyle()
                        }
                        .padding(.bottom, 10)

                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text("Certificates").font(.headline)
                                Spacer()
                                Button(action: {}) {
                                    Image(systemName: "plus.circle.fill")
                                        .foregroundColor(Color.colorPurple)
                                        .font(.title2)
                                }
                            }
                            .padding(.trailing)
                            TextField("Certificate Name", text: $certificateName)
                                .formFieldStyle()
                        }
                        .padding(.bottom, 10)

                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text("Certificate File").font(.headline)
                                Spacer()
                                Button(action: {}) {
                                    Image(systemName: "plus.circle.fill")
                                        .foregroundColor(Color.colorPurple)
                                        .font(.title2)
                                }
                            }
                            .padding(.trailing)
                            TextField("Please press here to add a file", text: $certificateFile)
                                .formFieldStyle()
                        }
                        .padding(.bottom, 10)

                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text("Url").font(.headline)
                                Spacer()
                                Button(action: {}) {
                                    Image(systemName: "plus.circle.fill")
                                        .foregroundColor(Color.colorPurple)
                                        .font(.title2)
                                }
                            }
                            .padding(.trailing)
                            TextField("Type here", text: $optionalURL)
                                .formFieldStyle()
                        }

                        Divider()

                        VStack(alignment: .leading, spacing: 8) {
                            Text("Expiry Date").font(.headline)
                            DatePicker("Choose", selection: $expiryDate, displayedComponents: .date)
                                .datePickerStyle(.compact)
                                .formFieldStyle()
                                .padding(.top)
                        }
                        .padding(.bottom, 10)

                        VStack(alignment: .leading, spacing: 8) {
                            Text("Years of Experience").font(.headline)
                            Menu {
                                ForEach(yearsOfExperienceOptions, id: \.self) { option in
                                    Button(option) {
                                        selectedExperience = option
                                    }
                                }
                            } label: {
                                HStack {
                                    Text(selectedExperience.isEmpty ? "Choose" : selectedExperience)
                                    Spacer()
                                    Image(systemName: "chevron.down")
                                }
                                .foregroundColor(.black)
                                .formFieldStyle()
                            }
                        }
                        .padding(.bottom, 10)

                        VStack(alignment: .leading, spacing: 8) {
                            Text("Areas of Expertise").font(.headline)
                            Menu {
                                ForEach(areasOfExpertiseOptions, id: \.self) { option in
                                    Button(option) {
                                        selectedExpertise = option
                                    }
                                }
                            } label: {
                                HStack {
                                    Text(selectedExpertise.isEmpty ? "Choose" : selectedExpertise)
                                    Spacer()
                                    Image(systemName: "chevron.down")
                                }
                                .foregroundColor(.black)
                                .formFieldStyle()
                            }
                        }
                        .padding(.bottom, 10)

                        VStack(alignment: .leading, spacing: 8) {
                            Text("Availability").font(.headline)
                            DatePicker("Choose", selection: $availabilityDate, displayedComponents: .date)
                                .datePickerStyle(.automatic)
                                .formFieldStyle()
                                .padding(.top)
                        }
                    }

                    Button(action: {
                        navigateToAuth = true
                    }) {
                        Text("Save")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 48)
                            .background(Color.colorPurple)
                            .cornerRadius(8)
                            .padding(.vertical)
                    }
                    .navigationDestination(isPresented: $navigateToAuth) {
                        AuthView()
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top)
            }
            .navigationBarBackButtonHidden(false)

            .confirmationDialog("Select Image Source", isPresented: $showSourceTypeDialog, titleVisibility: .visible) {
                if cameraGranted {
                    Button("Camera") {
                        sourceType = .camera
                        showImagePicker = true
                    }
                }
                if photoLibraryGranted {
                    Button("Photo Library") {
                        sourceType = .photoLibrary
                        showImagePicker = true
                    }
                }
                Button("Cancel", role: .cancel) { }
            }

            .sheet(isPresented: $showImagePicker) {
                ImagePicker(selectedImage: $profileImage, sourceType: sourceType)
            }
        }
    }

    // MARK: - Permission Request Logic
    private func requestPermissionsAndShowPicker() {
        var cameraDone = false
        var photoDone = false

        func tryShowDialog() {
            if cameraDone && photoDone {
                showSourceTypeDialog = true
            }
        }

        AVCaptureDevice.requestAccess(for: .video) { granted in
            DispatchQueue.main.async {
                self.cameraGranted = granted
                cameraDone = true
                tryShowDialog()
            }
        }

        PHPhotoLibrary.requestAuthorization { status in
            DispatchQueue.main.async {
                self.photoLibraryGranted = (status == .authorized || status == .limited)
                photoDone = true
                tryShowDialog()
            }
        }
    }
}

#Preview {
    TrainerDetailView()
}
