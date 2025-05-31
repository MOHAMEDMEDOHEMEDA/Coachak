//
//  DocumentPicker.swift
//  Coashak
//
//  Created by Mohamed Magdy on 18/05/2025.
//

import Foundation
import SwiftUI

struct DocumentPicker: UIViewControllerRepresentable {
    @Binding var fileURL: URL?

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        let picker = UIDocumentPickerViewController(forOpeningContentTypes: [.item], asCopy: true)
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {}

    class Coordinator: NSObject, UIDocumentPickerDelegate {
        let parent: DocumentPicker

        init(_ parent: DocumentPicker) {
            self.parent = parent
        }

        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            parent.fileURL = urls.first
        }

        func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {}
    }
}
