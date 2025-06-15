//
//  TrineeDetailView.swift
//  Coashak
//
//  Created by Mohamed Magdy on 08/12/2024.
//  Modified by Manus on 30/05/2025 for integration.
//

import SwiftUI
import AVFoundation
import PhotosUI
import UIKit

// Main container view that initializes and provides the ViewModel
struct TraineeDataView: View {
    // Create the ViewModel instance here as a @StateObject
    @StateObject private var viewModel = UpdateClientViewModel()
    
    var body: some View {
        NavigationView {
            // Inject the ViewModel into the environment for child views
            TraineeData1View()
                .environmentObject(viewModel)
        }
    }
}

struct GoalOption: Identifiable {
    let id = UUID()
    let rawValue: String
    let displayName: String
    let imageName: String
}

struct TraineeData1View: View {
    @State private var selectedGoal: FitnessGoal? = .loseWeight
    @State private var otherGoal: String = ""
    @State private var isOtherSelected: Bool = false

    @EnvironmentObject var viewModel: UpdateClientViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("What is your goal?")
                .font(.title2)
                .bold()

            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                ForEach(FitnessGoal.allCases) { goal in
                    GoalButton(goal: goal, selectedGoal: Binding(
                        get: { selectedGoal == goal ? goal : nil },
                        set: { newGoal in
                            selectedGoal = newGoal
                            isOtherSelected = false
                        })
                    )
                }
            }

            Button(action: {
                isOtherSelected.toggle()
                if isOtherSelected {
                    selectedGoal = nil
                }
            }) {
                HStack {
                    Image(systemName: isOtherSelected ? "checkmark.circle.fill" : "circle")
                        .foregroundStyle(isOtherSelected ? Color.colorPurple : Color.primary)
                    Text("Other")
                        .foregroundColor(.primary)
                }
            }

            if isOtherSelected {
                TextField("Type here", text: $otherGoal)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }

            Spacer()

            NavigationLink(destination: TraineeData2View().environmentObject(viewModel)) {
                Text("Next")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.colorPurple)
                    .cornerRadius(8)
            }
//            .simultaneousGesture(TapGesture().onEnded {
//                if isOtherSelected {
//                    (((viewModel.fitnessGoal = FitnessGoal(rawValue: otherGoal.camelCased()) ?? .loseWeight).rawValue).rawValue).rawValue
//                } else if let selected = selectedGoal {
//                    viewModel.fitnessGoal = selected
//                }
//                print("✅ Fitness goal set to: \(viewModel.fitnessGoal)")
//            })
        }
        .padding()
        .toolbar {
            ToolbarItem(placement: .principal) {
                IndicatorTitle(currentTab: 0, numberOfTabs: 6)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}
extension String {
    func camelCased() -> String {
        self.lowercased()
            .replacingOccurrences(of: " ", with: "")
    }
}



// MARK: - Fitness Level View
struct TraineeData2View: View {
    @EnvironmentObject var viewModel: UpdateClientViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("What is your current fitness level?")
                .font(.title2)
                .bold()
            
            ForEach(FitnessLevel.allCases) { level in
                Button(action: {
                    viewModel.fitnessLevel = level
                }) {
                    HStack {
                        Image(systemName: viewModel.fitnessLevel == level ? "checkmark.circle.fill" : "circle")
                            .foregroundStyle(viewModel.fitnessLevel == level ? Color.colorPurple : Color.primary)
                        Text(level.displayName)
                            .foregroundColor(.primary)
                    }
                }
            }
            
            Spacer()
            
            NavigationLink(destination: TraineeDataAgeView().environmentObject(viewModel)) {
                Text("Next")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.colorPurple)
                    .cornerRadius(8)
            }
        }
        .padding()
        .toolbar {
            ToolbarItem(placement: .principal) {
                IndicatorTitle(currentTab: 1, numberOfTabs: 6)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Age Selection View
struct TraineeDataAgeView: View {
    @State private var age: Int = 20 // Local state for picker
    // Access the shared ViewModel from the environment
    @EnvironmentObject var viewModel: UpdateClientViewModel
    
    var body: some View {
        VStack(spacing: 20) {
            Text("What is your age?")
                .font(.title2)
                .bold()
            
            Text("Your age helps us tailor personalized fitness recommendations just for you!")
                .multilineTextAlignment(.center)
                .font(.subheadline)
                .foregroundColor(.gray)
            
            Picker("Age", selection: $age) {
                ForEach(10...60, id: \.self) { value in
                    Text("\(value)")
                        .font(.system(size: 30))
                        .foregroundColor(.white)
                        .tag(value)
                    
                }
                
            }
            .pickerStyle(WheelPickerStyle())
            .frame(width: 135, height: 400, alignment: .center)
            .background(
                RoundedRectangle(cornerRadius: 70)
                    .fill(Color.colorPurple) // Example background
            )
            .overlay(
                RoundedRectangle(cornerRadius: 70)
                    .stroke(Color.gray.opacity(0.3), lineWidth: 2)
            )
            
            Spacer()
            
            // Pass the environment object down implicitly
            NavigationLink(destination: TraineeDataHeightWeightView().environmentObject(viewModel)) {
                Text("Next")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.colorPurple)
                    .cornerRadius(8)
            }
            .simultaneousGesture(TapGesture().onEnded {
                // Update the shared ViewModel
                viewModel.age = age
                print("✅ Age set to: \(viewModel.age)")
            })
        }
        .padding()
        .toolbar {
            ToolbarItem(placement: .principal) {
                IndicatorTitle(currentTab: 2, numberOfTabs: 6)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Height & Weight View
struct TraineeDataHeightWeightView: View {
    @State private var selectedHeight: Int = 170
    @State private var selectedHeightUnit: String = "cm"
    @State private var selectedWeight: Int = 75
    @State private var selectedWeightUnit: String = "kg"
    @State private var activePicker: ActivePicker? = nil
    // Access the shared ViewModel from the environment
    @EnvironmentObject var viewModel: UpdateClientViewModel
    
    enum ActivePicker {
        case height
        case weight
    }
    
    var body: some View {
        ZStack {
            VStack(spacing: 20) {
                Text("What is your height?")
                    .font(.title2)
                    .bold()
                
                Button(action: { activePicker = .height }) {
                    HStack {
                        Text("\(selectedHeight) \(selectedHeightUnit)")
                            .foregroundColor(.primary)
                        Spacer()
                        Image(systemName: "chevron.down")
                            .foregroundColor(.gray)
                    }
                    .padding()
                    .frame(height: 48)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                    )
                }
                
                Text("What is your weight?")
                    .font(.title2)
                    .bold()
                
                Button(action: { activePicker = .weight }) {
                    HStack {
                        Text("\(selectedWeight) \(selectedWeightUnit)")
                            .foregroundColor(.primary)
                        Spacer()
                        Image(systemName: "chevron.down")
                            .foregroundColor(.gray)
                    }
                    .padding()
                    .frame(height: 48)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                    )
                }
                
                Spacer()
                
                // Pass the environment object down implicitly
                NavigationLink(destination: HealthConditionsAndAllergiesView().environmentObject(viewModel)) {
                    Text("Next")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.colorPurple)
                        .cornerRadius(8)
                }
                .simultaneousGesture(TapGesture().onEnded {
                    // Update the shared ViewModel with converted values
                    if selectedHeightUnit == "ft" {
                        viewModel.height = Int(Double(selectedHeight) * 30.48)
                    } else {
                        viewModel.height = selectedHeight
                    }
                    
                    if selectedWeightUnit == "lbs" {
                        viewModel.weight = Int(Double(selectedWeight) * 0.453592)
                    } else {
                        viewModel.weight = selectedWeight
                    }
                    print("✅ Updated height (cm): \(viewModel.height), weight (kg): \(viewModel.weight)")
                })
            }
            .padding()
            .toolbar {
                ToolbarItem(placement: .principal) {
                    IndicatorTitle(currentTab: 3, numberOfTabs: 6)
                }
            }
            
            // Height Picker Popup
            if activePicker == .height {
                PickerPopupOverlay(activePicker: $activePicker) {
                    // Assuming CustomPickerPopupView exists and works with these bindings
                    CustomPickerPopupView(
                        title: "Select Your Height",
                        range: 100...250,
                        units: ["cm", "ft"],
                        selection: $selectedHeight,
                        selectedUnit: $selectedHeightUnit,
                        onDismiss: { activePicker = nil }
                    )
                }
            }
            
            // Weight Picker Popup
            if activePicker == .weight {
                PickerPopupOverlay(activePicker: $activePicker) {
                    // Assuming CustomPickerPopupView exists and works with these bindings
                    CustomPickerPopupView(
                        title: "Select Your Weight",
                        range: 30...150,
                        units: ["kg", "lbs"],
                        selection: $selectedWeight,
                        selectedUnit: $selectedWeightUnit,
                        onDismiss: { activePicker = nil }
                    )
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

// Helper View for Picker Popups
struct PickerPopupOverlay<Content: View>: View {
    @Binding var activePicker: TraineeDataHeightWeightView.ActivePicker?
    let content: () -> Content
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .ignoresSafeArea()
                .onTapGesture { activePicker = nil }
            
            content()
                .frame(width: 300, height: 300) // Example frame
                .background(Color(UIColor.systemBackground)) // Use system background for light/dark mode
                .cornerRadius(12)
                .shadow(radius: 10)
                .transition(.scale)
                .zIndex(1)
        }
    }
}

// MARK: - Health Conditions & Allergies View
struct HealthConditionsAndAllergiesView: View {
    @State private var hasHealthConditions: Bool? = nil
    @State private var selectedHealthConditions: [String] = []
    @State private var otherHealthCondition: String = ""
    @State private var hasAllergies: Bool? = nil
    @State private var selectedAllergies: [String] = []
    @State private var otherAllergy: String = ""
    // Access the shared ViewModel from the environment
    @EnvironmentObject var viewModel: UpdateClientViewModel
    
    let healthConditionOptions = ["Diabetes", "Asthma", "Heart Conditions", "Other"]
    let allergyOptions = ["Pollen", "Dust", "Food", "Medicine", "Other"]
    
    var body: some View {
        VStack(spacing: 20) {
            // ProgressView might be better placed in the toolbar or outside the scrollview
            // ProgressView(value: 0.4) // Example progress
            //     .progressViewStyle(LinearProgressViewStyle(tint: .colorPurple))
            
            ScrollView {
                VStack(alignment: .leading, spacing: 20) { // Added VStack for proper layout in ScrollView
                    // Health Conditions Section
                    Text("Do you have any health conditions?")
                        .font(.title2)
                        .bold()
                    
                    ToggleGroup(
                        title: "Yes",
                        isSelected: hasHealthConditions == true,
                        action: { hasHealthConditions = true }
                    )
                    ToggleGroup(
                        title: "No",
                        isSelected: hasHealthConditions == false,
                        action: {
                            hasHealthConditions = false
                            selectedHealthConditions.removeAll()
                            otherHealthCondition = ""
                        }
                    )
                    
                    if hasHealthConditions == true {
                        MultiSelectView(
                            title: "Select Health Conditions",
                            options: healthConditionOptions,
                            selectedOptions: $selectedHealthConditions,
                            otherCondition: $otherHealthCondition
                        )
                    }
                    
                    Divider()
                    
                    // Allergies Section
                    Text("Do you have any allergies?")
                        .font(.title2)
                        .bold()
                    
                    ToggleGroup(
                        title: "Yes",
                        isSelected: hasAllergies == true,
                        action: { hasAllergies = true }
                    )
                    ToggleGroup(
                        title: "No",
                        isSelected: hasAllergies == false,
                        action: {
                            hasAllergies = false
                            selectedAllergies.removeAll()
                            otherAllergy = ""
                        }
                    )
                    
                    if hasAllergies == true {
                        MultiSelectView(
                            title: "Select Allergies",
                            options: allergyOptions,
                            selectedOptions: $selectedAllergies,
                            otherCondition: $otherAllergy
                        )
                    }
                }
            }
            
            Spacer()
            
            // Pass the environment object down implicitly
            NavigationLink(destination: TraineeData5View().environmentObject(viewModel)) {
                Text("Next")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.colorPurple)
                    .cornerRadius(8)
            }
            .simultaneousGesture(TapGesture().onEnded {
                // Update the shared ViewModel
                var finalHealthConditions = selectedHealthConditions.filter { $0 != "Other" }
                if selectedHealthConditions.contains("Other") && !otherHealthCondition.trimmingCharacters(in: .whitespaces).isEmpty {
                    finalHealthConditions.append(otherHealthCondition.trimmingCharacters(in: .whitespaces))
                }
                viewModel.healthConditions = hasHealthConditions == true ? finalHealthConditions : []
                
                var finalAllergies = selectedAllergies.filter { $0 != "Other" }
                if selectedAllergies.contains("Other") && !otherAllergy.trimmingCharacters(in: .whitespaces).isEmpty {
                    finalAllergies.append(otherAllergy.trimmingCharacters(in: .whitespaces))
                }
                viewModel.allergies = hasAllergies == true ? finalAllergies : []
                
                print("✅ Health Conditions: \(viewModel.healthConditions)")
                print("✅ Allergies: \(viewModel.allergies)")
            })
        }
        .padding()
        .toolbar {
            ToolbarItem(placement: .principal) {
                IndicatorTitle(currentTab: 4, numberOfTabs: 6)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Profile Picture Upload View
struct TraineeData5View: View {
    @State private var profileImage: UIImage? = nil
    @State private var showImagePicker = false
    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @State private var cameraGranted: Bool = false
    @State private var photoLibraryGranted: Bool = false
    @State private var showSourceTypeDialog = false
    // Access the shared ViewModel from the environment
    @EnvironmentObject var viewModel: UpdateClientViewModel
    
    var body: some View {
        // Removed NavigationStack as it's already inside a NavigationView from TraineeDataView
        VStack(spacing: 20) {
            Text("Upload your profile. (Optional)")
                .font(.title2)
                .bold()
            
            ZStack {
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: 150, height: 150)
                    .cornerRadius(8)
                
                if let image = profileImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 150, height: 150)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                } else {
                    Image(systemName: "photo.on.rectangle.angled") // Placeholder icon
                        .font(.largeTitle)
                        .foregroundColor(.gray)
                }
            }
            .onTapGesture { // Allow tapping the image area to upload
                requestPermissionsAndShowPicker()
            }
            
            Button(action: {
                requestPermissionsAndShowPicker()
            }) {
                Text("Upload Photo")
                    .font(.headline)
                    .padding(.horizontal)
                // .foregroundColor(.white)
                // .frame(width: 167, height: 32, alignment: .center)
                // .background(Color.colorMidPink) // Example color
                // .cornerRadius(8)
            }
            .buttonStyle(.bordered)
            
            Spacer()
            
            // Final Submit Button
            Button(action: {
                Task {
                    if let image = viewModel.profileImage {
                        print("✅ Profile image is set. Size: \(image.size)")
                    } else {
                        print("❌ Profile image is nil.")
                    }
                    await viewModel.updateClient()
                }
            }) {
                // Show loading indicator if needed
                if viewModel.isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.colorPurple.opacity(0.7))
                        .cornerRadius(8)
                } else {
                    Text("Finish") // Changed from "Next"
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.colorPurple)
                        .cornerRadius(8)
                }
            }
            .disabled(viewModel.isLoading)
            .navigationDestination(isPresented: $viewModel.navigateToHomePage) {
                MainTraineeTabView()
            }
            
            // Display error message if update fails
            if let errorMessage = viewModel.errorMessage {
                Text("Error: \(errorMessage)")
                    .foregroundColor(.red)
                    .padding(.top)
            }
        }
        .padding()
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showImagePicker) {
            // Assuming ImagePicker struct exists and works with these bindings
            ImagePicker(selectedImage: $profileImage, sourceType: sourceType)
        }
        .confirmationDialog("Choose Photo Source", isPresented: $showSourceTypeDialog, titleVisibility: .visible) {
            if cameraGranted {
                Button("Camera") {
                    self.sourceType = .camera
                    self.showImagePicker = true
                }
            }
            if photoLibraryGranted {
                Button("Photo Library") {
                    self.sourceType = .photoLibrary
                    self.showImagePicker = true
                }
            }
            Button("Cancel", role: .cancel) {}
        }
        .onChange(of: profileImage) { newImage in
            viewModel.profileImage = newImage
            print("✅ Profile image updated in ViewModel.")
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                IndicatorTitle(currentTab: 5, numberOfTabs: 6)
            }
        }
        // Request permissions on appear
        .onAppear {
            checkPermissions()
        }
    }
    
    
    // MARK: - Permissions and Picker Logic
    private func requestPermissionsAndShowPicker() {
        checkPermissions()
        if cameraGranted && photoLibraryGranted {
            showSourceTypeDialog = true
        } else {
            requestCameraAccess()
            requestPhotoLibraryAccess()
        }
    }
    
    private func checkPermissions() {
        cameraGranted = AVCaptureDevice.authorizationStatus(for: .video) == .authorized
        photoLibraryGranted = PHPhotoLibrary.authorizationStatus() == .authorized || PHPhotoLibrary.authorizationStatus() == .limited
    }
    
    private func requestCameraAccess() {
        AVCaptureDevice.requestAccess(for: .video) { granted in
            DispatchQueue.main.async {
                self.cameraGranted = granted
                if granted { self.showSourceTypeDialog = true }
            }
        }
    }
    
    private func requestPhotoLibraryAccess() {
        PHPhotoLibrary.requestAuthorization { status in
            DispatchQueue.main.async {
                self.photoLibraryGranted = (status == .authorized || status == .limited)
                if self.photoLibraryGranted { self.showSourceTypeDialog = true }
            }
        }
    }
    
    
}
// MARK: - Reusable Components (ToggleGroup, MultiSelectView, GoalButton, IndicatorTitle)

struct ToggleGroup: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(isSelected ? .colorPurple : .gray)
                Text(title)
                    .foregroundColor(.primary)
                Spacer()
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 8).stroke(isSelected ? Color.colorPurple : Color.gray.opacity(0.5), lineWidth: 1))
        }
    }
}

struct MultiSelectView: View {
    let title: String
    let options: [String]
    @Binding var selectedOptions: [String]
    @Binding var otherCondition: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            // Text(title).font(.headline) // Title might be redundant if section header exists
            ForEach(options, id: \.self) { option in
                Button(action: {
                    if selectedOptions.contains(option) {
                        selectedOptions.removeAll { $0 == option }
                        if option == "Other" { otherCondition = "" } // Clear other text if "Other" is deselected
                    } else {
                        selectedOptions.append(option)
                    }
                }) {
                    HStack {
                        Image(systemName: selectedOptions.contains(option) ? "checkmark.circle.fill" : "circle")
                            .foregroundColor(selectedOptions.contains(option) ? .colorPurple : .gray)
                        Text(option)
                            .foregroundColor(.primary)
                        Spacer()
                    }
                }
            }
            if selectedOptions.contains("Other") {
                TextField("Please specify", text: $otherCondition)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                // .formFieldStyle() // Use a standard or defined style
                    .padding(.top, 5)
            }
        }
        .padding(.vertical)
    }
}

struct GoalButton: View {
    let goal: FitnessGoal
    @Binding var selectedGoal: FitnessGoal?

    var isSelected: Bool {
        selectedGoal == goal
    }
    
    var body: some View {
        Button(action: {
            selectedGoal = goal
        }) {
            VStack(alignment: .center, spacing: 8) {
                HStack {
                    Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                        .foregroundStyle(isSelected ? Color.colorPurple : Color.primary)
                    Spacer()
                }
                .padding(.horizontal)
                
                Image(goal.imageName) // Ensure FitnessGoal has imageName property
                    .resizable()
                    .scaledToFit()
                    .frame(height: 80)
                
                Text(goal.displayName) // Ensure FitnessGoal has displayName property
                    .font(.subheadline)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.primary)
            }
            .padding()
            .frame(maxWidth: .infinity, minHeight: 160)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? Color.colorPurple : Color.gray.opacity(0.3),
                            lineWidth: isSelected ? 2 : 1)
            )
        }
    }
}


struct IndicatorTitle: View {
    let currentTab: Int // Changed to let as it's determined by parent
    let numberOfTabs: Int
    
    var body: some View {
        HStack(spacing: 8) {
            ForEach(0..<numberOfTabs, id: \.self) { index in
                if index == currentTab {
                    Capsule()
                        .fill(Color.colorPurple)
                        .frame(width: 24, height: 8)
                } else {
                    Circle()
                        .fill(Color.colorCapsule.opacity(0.3))
                        .frame(width: 8, height: 8)
                }
            }
        }
        .animation(.easeInOut(duration: 0.2), value: currentTab) // Animate based on currentTab change
        .padding(.vertical)
    }
}

// MARK: - Preview
#Preview {
    TraineeDataView()
        .environmentObject(UpdateClientViewModel()) // Required for preview to work
}
