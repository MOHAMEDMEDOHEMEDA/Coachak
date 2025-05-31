//
//  ImagePicker.swift
//  Coashak
//
//  Created by Mohamed Magdy on 11/12/2024.
//

import SwiftUI
import PhotosUI
import UIKit

// MARK: - image picker

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    var sourceType: UIImagePickerController.SourceType = .photoLibrary
    var allowsEditing: Bool = false
    var onImageSelected: ((UIImage) -> Void)? = nil

    @Environment(\.presentationMode) var presentationMode

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = sourceType
        picker.allowsEditing = allowsEditing
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            let key: UIImagePickerController.InfoKey = parent.allowsEditing ? .editedImage : .originalImage
            if let image = info[key] as? UIImage {
                parent.selectedImage = image
                parent.onImageSelected?(image)
            }

            parent.presentationMode.wrappedValue.dismiss()
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}
