//
//  CreatePlanView 2.swift
//  Coashak
//
//  Created by Mohamed Magdy on 15/06/2025.
//


//
//  CreatePlanView.swift
//  Coashak
//
//  Created by Mohamed Magdy on 10/06/2025.
//

import SwiftUI

struct EditPlanView: View {
    @StateObject private var viewModel = CreatePlanViewModel()
    @State private var selectedImage: UIImage? = nil
    @State private var isShowingImagePicker = false
    @State private var showPhotoSourceSelection = false
    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .center){
                    profileImageSection
                        .padding(.top, 20)
                }

                VStack(alignment: .leading,spacing: 20) {
                    Text("Edit Plan")
                        .font(.title).bold()
                        .padding(.top)

                    VStack(alignment: .leading, spacing: 5) {
                        Text("Plan Name").bold()
                        TextField("e.g. Premium Plan", text: $viewModel.title)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray.opacity(0.3)))
                    }

                    VStack(alignment: .leading, spacing: 5) {
                        Text("Description").bold()
                        TextField("e.g. Will help in weight loss", text: $viewModel.description)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray.opacity(0.3)))
                    }

                    VStack(alignment: .leading, spacing: 5) {
                        Text("Price").bold()
                        TextField("e.g. $99", text: $viewModel.price)
                            .keyboardType(.numberPad)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray.opacity(0.3)))
                    }

                    VStack(alignment: .leading, spacing: 5) {
                        Text("Durations").bold()
                        TextField("4 Weeks", text: $viewModel.durationInWeeks)
                            .keyboardType(.numberPad)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray.opacity(0.3)))
                    }

                    Text("What's Included").bold()
                    Text("Select what services are included in this subscription plan")
                        .foregroundColor(.gray)
                        .font(.subheadline)

                    VStack {
                        CheckBoxCard(title: "Training Plan", subtitle: "Personalized workout routines and exercise programs", isSelected: $viewModel.hasTrainingPlan, color: .purple, icon: "dumbbell.fill")

                        CheckBoxCard(title: "Nutrition Plan", subtitle: "Custom meal plans and dietary guidance", isSelected: $viewModel.hasNutritionPlan, color: .pink, icon: "apple.logo")
                    }

                    HStack(spacing: 12) {
                        Button("Cancel") {
                            dismiss()
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(12)

                        Button("Edit Plan") {
                            Task {
                                await viewModel.savePlan()
                                dismiss()
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(LinearGradient(colors: [.colorPurple.opacity(0.8), .colorPurple], startPoint: .leading, endPoint: .trailing))
                        .foregroundColor(.white)
                        .cornerRadius(12)
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



struct EditPlanView_Previews: PreviewProvider {
    static var previews: some View {
        EditPlanView()
    }
}
