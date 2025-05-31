//
//  SubscriptionPlanCreationView.swift
//  Coashak
//
//  Created by Mohamed Magdy on 06/04/2025.
//


import SwiftUI

struct SubscriptionPlanCreationView: View {
    @State private var selectedPrice: String? = nil
    @State private var customPlanTitle = ""
    @State private var subscriptionFeatures = ["Weekly Progress Tracking", "Personalized Training Program"]
    @State private var newFeature = ""
    @State private var availabilityDate = Date()
    @State private var hasNutritionPlan: Bool? = nil

    @State private var sourceType: UIImagePickerController.SourceType = .camera
    @State private var showImagePicker = false
    @State private var showConfirmationDialog = false
    @State private var coachImage: UIImage? = nil

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                
                // Coach Image + Add Button
                ZStack(alignment: .bottomTrailing) {
                    Group {
                        if let image = coachImage {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFill()
                                .frame(height: 200)
                                .clipped()
                                .cornerRadius(10)
                        } else {
                            Rectangle()
                                .fill(Color.gray.opacity(0.2))
                                .frame(height: 200)
                                .overlay(Text("Coach Image"))
                                .cornerRadius(10)
                        }
                    }

                    Button(action: {
                        showConfirmationDialog = true
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title)
                            .foregroundColor(.purple)
                            .padding()
                    }
                    .confirmationDialog("Choose Photo", isPresented: $showConfirmationDialog) {
                        Button("Camera") {
                            sourceType = .camera
                            showImagePicker = true
                        }
                        Button("Photo Library") {
                            sourceType = .photoLibrary
                            showImagePicker = true
                        }
                        Button("Cancel", role: .cancel) {}
                    }
                }

                // Rest of your form...
                // (Name, Subscription Options, Features Offered, Availability, Nutrition Plan, Buttons...)

                VStack(alignment: .leading, spacing: 4) {
                    Text("Name")
                        .font(.headline)
                    Text("Mohamed Sanad")
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text("Subscription")
                        .font(.headline)

                    HStack(spacing: 10) {
                        ForEach(["$30\nMonthly", "$80\n3 Months", "$150\n6 Months"], id: \.self) { option in
                            Button(action: {
                                selectedPrice = option
                            }) {
                                Text(option)
                                    .multilineTextAlignment(.center)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(selectedPrice == option ? Color.purple.opacity(0.1) : Color(.systemGray6))
                                    .cornerRadius(10)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(selectedPrice == option ? Color.purple : Color.clear, lineWidth: 2)
                                    )
                            }
                        }
                    }

                    Text("If none of the above options please write down your subscription’s title")
                        .font(.subheadline)
                        .foregroundColor(.gray)

                    TextField("Type here", text: $customPlanTitle)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }

                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("What does the subscription offer?")
                            .font(.headline)
                        Spacer()
                        Button(action: {
                            if !newFeature.isEmpty {
                                subscriptionFeatures.append(newFeature)
                                newFeature = ""
                            }
                        }) {
                            Image(systemName: "plus.circle.fill")
                                .foregroundColor(.purple)
                        }
                    }

                    ForEach(subscriptionFeatures, id: \.self) { feature in
                        Text(feature)
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color(.systemGray6))
                            .cornerRadius(10)
                    }

                    TextField("Add new feature", text: $newFeature)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text("Availability")
                        .font(.headline)

                    DatePicker("Choose", selection: $availabilityDate, displayedComponents: [.date, .hourAndMinute])
                        .datePickerStyle(CompactDatePickerStyle())
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text("Nutrition Plan")
                        .font(.headline)

                    HStack {
                        RadioButton(title: "Yes", selected: hasNutritionPlan == true) {
                            hasNutritionPlan = true
                        }
                        RadioButton(title: "No", selected: hasNutritionPlan == false) {
                            hasNutritionPlan = false
                        }
                    }
                }

                HStack(spacing: 16) {
                    Button("Cancel") {
                        // Cancel action
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.gray.opacity(0.6))
                    .foregroundColor(.white)
                    .cornerRadius(10)

                    Button("Save") {
                        // Save action
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.purple)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                .padding(.top)

            }
            .padding()
            .sheet(isPresented: $showImagePicker) {
                ImagePicker(selectedImage: $coachImage, sourceType: sourceType)
            }
        }
    }
}

// Custom Radio Button
struct RadioButton: View {
    var title: String
    var selected: Bool
    var action: () -> Void

    var body: some View {
        HStack {
            Circle()
                .stroke(selected ? Color.purple : Color.gray, lineWidth: 2)
                .frame(width: 20, height: 20)
                .overlay(
                    Circle()
                        .fill(selected ? Color.purple : Color.clear)
                        .frame(width: 12, height: 12)
                )
            Text(title)
        }
        .onTapGesture {
            action()
        }
        .padding(.trailing, 12)
    }
}

#Preview {
    SubscriptionPlanCreationView()
}
