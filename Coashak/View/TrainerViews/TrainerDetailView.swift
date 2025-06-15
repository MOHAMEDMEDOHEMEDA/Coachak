//
//  TrainerDetailView.swift
//  Coashak
//
//  Created by Mohamed Magdy on 15/12/2024.
//

import SwiftUI
import PhotosUI
import AVFoundation


// MARK: - Subcomponents

struct ProfileImageUploadSection: View {
    @ObservedObject var updateVM: UpdateTrainerViewModel
    var onUploadTapped: () -> Void
    
    var body: some View {
        VStack {
            ZStack {
                Circle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: 160, height: 160)
                
                if let image = updateVM.profileImage {
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
                onUploadTapped()
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
    }
}

struct BioSection: View {
    @ObservedObject var updateVM: UpdateTrainerViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Bio")
                .font(.headline)
            
            ZStack(alignment: .topLeading) {
                if updateVM.bio.isEmpty {
                    Text("Tell Clients About Yourself")
                        .foregroundColor(.gray)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 12)
                }
                
                TextEditor(text: $updateVM.bio)
                    .padding(4)
            }
            .frame(height: 150)
            .background(Color(.systemGray6))
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.gray.opacity(0.3))
            )
        }
    }
}

struct CertificatesSection: View {
    @ObservedObject var certVM: CertificateViewModel
    @Binding var showCertificateSheet: Bool
    
    @State private var showingError = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Certificates")
                    .font(.headline)
                Spacer()
                Button {
                    showCertificateSheet = true
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .foregroundColor(Color.colorPurple)
                        .font(.title2)
                }
            }
            
            if certVM.isLoading && certVM.certificatesInfo.isEmpty {
                ProgressView()
                    .frame(maxWidth: .infinity)
            } else if certVM.certificatesInfo.isEmpty {
                Text("No certificates added yet")
                    .foregroundColor(.gray)
                    .font(.subheadline)
            } else {
                ForEach(certVM.certificatesInfo, id: \.id) { cert in
                    CertificateRow(cert: cert)
                }
            }
        }
        .alert("Error", isPresented: $showingError, presenting: certVM.errorMessage) { _ in
            Button("OK", role: .cancel) { }
        } message: { message in
            Text(message)
        }
        .onChange(of: certVM.errorMessage) { newValue in
            showingError = newValue != nil
        }
    }
}
struct CertificateRow: View {
    let cert: CertificateModel

    var body: some View {
        HStack(spacing: 2) {
            Text(cert.name)
                .font(.subheadline)
                .bold()
            Text(cert.issuingOrganization)
                .font(.caption)
                .foregroundColor(.gray)
        }
        .padding(.vertical, 4)
    }
}


struct ExperienceSection: View {
    @ObservedObject var updateVM: UpdateTrainerViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Years of Experience")
                .font(.headline)
            Menu {
                ForEach(1...20, id: \.self) { option in
                    Button("\(option)") {
                        updateVM.yearsOfExperience = option
                    }
                }
            } label: {
                HStack {
                    Text(updateVM.yearsOfExperience == 0 ? "Choose" : "\(updateVM.yearsOfExperience) years")
                    Spacer()
                    Image(systemName: "chevron.down")
                }
                .foregroundColor(.black)
                .formFieldStyle()
            }
        }
    }
}

struct PriceSection: View {
    @ObservedObject var updateVM: UpdateTrainerViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Price per Session")
                .font(.headline)
            TextField("Enter price...", text: $updateVM.pricePerSession)
                .keyboardType(.decimalPad)
                .formFieldStyle()
        }
    }
}

// Then modify the AvailabilitySection:
struct AvailabilitySection: View {
    @ObservedObject var updateVM: UpdateTrainerViewModel
    let daysOfWeek = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Availability")
                .font(.headline)
            
            LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 3), spacing: 12) {
                ForEach(daysOfWeek, id: \.self) { day in
                    Button {
                        if let index = updateVM.availableDays.firstIndex(of: day) {
                            updateVM.availableDays.remove(at: index)
                        } else {
                            updateVM.availableDays.append(day)
                        }
                    } label: {
                        Text(day)
                            .padding(.vertical, 8)
                            .padding(.horizontal, 16)
                            .frame(maxWidth: .infinity)
                            .background(updateVM.availableDays.contains(day) ? Color.colorMidPink : Color.clear)
                            .foregroundColor(updateVM.availableDays.contains(day) ? .white : .black)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color.colorMidPink, lineWidth: 1)
                            )
                            .clipShape(Capsule())
                    }
                }
            }
            .padding(.top, 4)
        }
    }
}
struct SaveButton: View {
    @ObservedObject var updateVM: UpdateTrainerViewModel
    
    var body: some View {
        Button {
            Task {
                await updateVM.updateTrainer()
            }
        } label: {
            if updateVM.isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity)
                    .frame(height: 48)
            } else {
                Text("Save")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 48)
                    .background(Color.colorPurple)
                    .cornerRadius(8)
                    .padding(.vertical)
            }
        }
    }
}

// MARK: - Main View

struct TrainerDetailView: View {
    @StateObject private var certVM = CertificateViewModel()
    @StateObject private var updateVM = UpdateTrainerViewModel()
    
    @State private var showImagePicker = false
    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @State private var cameraGranted: Bool = false
    @State private var photoLibraryGranted: Bool = false
    @State private var showSourceTypeDialog = false
    
    @State private var showCertificateSheet = false
    @State private var tempCertificateName = ""
    @State private var tempOrganization = ""
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Create Trainer Profile")
                        .font(.title2)
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.top)
                    
                    ProfileImageUploadSection(updateVM: updateVM) {
                        requestPermissionsAndShowPicker()
                    }

                    Divider()
                    
                    BioSection(updateVM: updateVM)
                    
                    Divider()
                    
                    CertificatesSection(certVM: certVM, showCertificateSheet: $showCertificateSheet)
                        .onChange(of: showCertificateSheet) { isShowing in
                            if !isShowing {
                                // Reset error when sheet dismisses
                                certVM.errorMessage = nil
                            }
                        }
                    
                    Divider()
                    
                    ExperienceSection(updateVM: updateVM)
                    
                    PriceSection(updateVM: updateVM)
                    
                    AvailabilitySection(updateVM: updateVM)
                    
                    SaveButton(updateVM: updateVM)
                        .navigationDestination(isPresented: $updateVM.navigateToHomePage) {
                            MainTrainerTabView()
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
                ImagePicker(selectedImage: $updateVM.profileImage, sourceType: sourceType)
            }
            .refreshable {
                await certVM.fetchCertificates()
            }
            .sheet(isPresented: $showCertificateSheet) {
                CertificateSheetView(
                    tempCertificateName: $tempCertificateName,
                    tempOrganization: $tempOrganization,
                    showCertificateSheet: $showCertificateSheet,
                    certVM: certVM
                )
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

struct CertificateSheetView: View {
    @Binding var tempCertificateName: String
    @Binding var tempOrganization: String
    @Binding var showCertificateSheet: Bool
    @ObservedObject var certVM: CertificateViewModel
    
    @State private var showingError = false
    
    private var isFormValid: Bool {
        !tempCertificateName.trimmingCharacters(in: .whitespaces).isEmpty &&
        !tempOrganization.trimmingCharacters(in: .whitespaces).isEmpty
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Certificate Name", text: $tempCertificateName)
                    TextField("Issuing Organization", text: $tempOrganization)
                }
                
                if certVM.isLoading {
                    Section {
                        ProgressView()
                    }
                }
            }
            .navigationTitle("Add Certificate")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        showCertificateSheet = false
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        Task {
                            await saveCertificate()
                        }
                    }
                    .disabled(!isFormValid || certVM.isLoading)
                }
            }
            .alert("Error", isPresented: $showingError, presenting: certVM.errorMessage) { _ in
                Button("OK", role: .cancel) { }
            } message: { message in
                Text(message)
            }
            .onChange(of: certVM.errorMessage) { newValue in
                showingError = newValue != nil
            }
        }
        .presentationDetents([.medium])
    }
    
    private func saveCertificate() async {
        let newCert = CertificateModel(
            name: tempCertificateName.trimmingCharacters(in: .whitespaces),
            issuingOrganization: tempOrganization.trimmingCharacters(in: .whitespaces)
        )
        
        await certVM.addCertificate(newCert)
        
        if certVM.errorMessage == nil {
            tempCertificateName = ""
            tempOrganization = ""
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                showCertificateSheet = false
            }
        }

    }
}
#Preview {
    TrainerDetailView()
}
