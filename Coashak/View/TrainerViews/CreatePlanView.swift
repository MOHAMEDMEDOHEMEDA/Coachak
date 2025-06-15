//
//  CreatePlanView.swift
//  Coashak
//
//  Created by Mohamed Magdy on 10/06/2025.
//

import SwiftUI

struct CreatePlanView: View {
    @StateObject private var viewModel = CreatePlanViewModel()
    @State private var selectedImage: UIImage? = nil
    @State private var isShowingImagePicker = false
    @State private var showPhotoSourceSelection = false
    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary


    var body: some View {
        NavigationView {
            ScrollView {
                
                VStack(alignment: .center){
                    profileImageSection
                        .padding(.top, 20)
                }
                VStack(alignment: .leading,spacing: 20) {
             

                    // Subscription Title
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Subscription Title").bold()
                        TextField("Enter Title", text: $viewModel.title)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }

                    // Description
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Description").bold()
                        TextField("Enter Description", text: $viewModel.description)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }

                    // Price
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Price (USD)").bold()
                        TextField("Enter Price", text: $viewModel.price)
                            .keyboardType(.numberPad)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }

                    // Duration
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Duration (in weeks)").bold()
                        TextField("Enter Duration", text: $viewModel.durationInWeeks)
                            .keyboardType(.numberPad)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }

                   // training Plan (unchanged, but uses RadioButtons)
                    
                    Text("Includes Training Plan").bold()

                    VStack(alignment: .leading) {
                        HStack {
                            RadioButton(label: "Yes", isSelected: viewModel.hasTrainingPlan == true) {
                                viewModel.hasTrainingPlan = true
                            }
                            RadioButton(label: "No", isSelected: viewModel.hasTrainingPlan == false) {
                                viewModel.hasTrainingPlan = false
                            }
                        }
                    }

                    // Nutrition Plan (unchanged, but uses RadioButtons)
                    Text("Nutrition Plan").bold()

                    VStack(alignment: .leading) {
                        HStack {
                            RadioButton(label: "Yes", isSelected: viewModel.hasNutritionPlan == true) {
                                viewModel.hasNutritionPlan = true
                            }
                            RadioButton(label: "No", isSelected: viewModel.hasNutritionPlan == false) {
                                viewModel.hasNutritionPlan = false
                            }
                        }
                    }

                    // Save/Cancel Buttons
                    HStack {
                        Button("Cancel") {
                            // Handle cancel
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(10)

                        Button("Save") {
                            Task {
                                await viewModel.savePlan()
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.colorPurple)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                }
                .padding()
                .sheet(isPresented: $isShowingImagePicker) {
                    ImagePicker(selectedImage: $selectedImage, sourceType: sourceType, allowsEditing: false)
                }
            }
            .navigationTitle("")
            .navigationBarHidden(true)
        }
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


}

struct RadioButton: View {
    var label: String
    var isSelected: Bool
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                Circle()
                    .strokeBorder(Color.black, lineWidth: 1)
                    .background(Circle().fill(isSelected ? Color.colorPurple : Color.white))
                    .frame(width: 20, height: 20)
                Text(label)
            }
        }
        .foregroundColor(.black)
    }
}

struct CoachFormView_Previews: PreviewProvider {
    static var previews: some View {
        CreatePlanView()
    }
}
