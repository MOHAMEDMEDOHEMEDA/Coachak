//
//  EditTraineeProfileView.swift
//  Coashak
//
//  Created by Mohamed Magdy on 22/12/2024.
//

import SwiftUI

import SwiftUI

struct EditTraineeProfileView: View {
    @State private var name = "Rawan"
    @State private var gender = "Female"
    @State private var birthday = "3 Apr 2003"
    @State private var email = "rawan@gmail.com"
    @State private var height = "170 cm"
    @State private var weight = "60 Kg"
    @State private var goal = "Weight Loss"
    @State private var fitnessLevel = "Beginner"
    @State private var selectedImage: UIImage? = nil
    @State private var isShowingImagePicker = false
    @State private var isChangePasswordPresented = false
    @State private var sourceType: UIImagePickerController.SourceType = .camera
    @State private var showImagePicker = false

    var body: some View {
        VStack(spacing: 0) {
            profileImageSection
                .frame(height: UIScreen.main.bounds.height / 4)
            
            Form {
                Section(header: Text("Personal Information")) {
                    EditableRow(title: "Name", value: $name)
                    EditableRow(title: "Gender", value: $gender)
                    EditableRow(title: "Birthday", value: $birthday)
                    EditableRow(title: "Email", value: $email)
                    EditableRow(title: "Height", value: $height)
                    EditableRow(title: "Weight", value: $weight)
                    EditableRow(title: "Goal", value: $goal)
                    EditableRow(title: "Fitness Level", value: $fitnessLevel)
                }
            }
            .padding(.top,20)
            
            Button(action: {
                
            }) {
                Text("Save")
                    .font(.system(size: 20))
                    .foregroundColor(.white)
                    .frame(width: 143, height: 40, alignment: .center)
                    .background(Color.colorPurple)
                    .cornerRadius(8)
            }
            .padding()
            
        }
        .background(Color.gray.opacity(0.1))
        .navigationTitle("Edit Profile")
        .navigationBarItems(trailing: Button("Save") {
            // Save changes action
        })
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
            Button(action: {
                showActionSheet()
            }) {
                Text("Edit")
                    .foregroundColor(.colorPurple)
                    .fontWeight(.medium)
            }
        }
        .frame(maxWidth: .infinity)
    }
    

    // MARK: - Action Sheet for Image Selection
    private func showActionSheet() {
        let actionSheet = UIAlertController(title: "Choose Photo", message: nil, preferredStyle: .actionSheet)

        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default) { _ in
            sourceType = .camera
            showImagePicker = true
        })

        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default) { _ in
            sourceType = .photoLibrary
            showImagePicker = true
        })

        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))

        if let windowScene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            if let rootWindow = windowScene.windows.first(where: { $0.isKeyWindow }) {
                rootWindow.rootViewController?.present(actionSheet, animated: true, completion: nil)
            }
        }
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
        .padding(.vertical, 8)
    }
}

#Preview {
    EditTraineeProfileView()
}
