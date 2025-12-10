//
//  DocumentPicker.swift
//  Bomberman
//
//  Created by Sergey on 10.12.2025.
//

import SwiftUI
import UniformTypeIdentifiers

struct DocumentPicker: UIViewControllerRepresentable {
    @Binding var selectedURL: URL?
    var allowedContentTypes: [UTType]
    
    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        let picker = UIDocumentPickerViewController(forOpeningContentTypes: allowedContentTypes)
        picker.delegate = context.coordinator
        picker.allowsMultipleSelection = false
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIDocumentPickerDelegate {
        let parent: DocumentPicker
        
        init(_ parent: DocumentPicker) {
            self.parent = parent
        }
        
        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            guard let url = urls.first else { return }
            
            guard url.startAccessingSecurityScopedResource() else {
                print("Не удалось получить доступ к файлу")
                return
            }
            
            defer {
                url.stopAccessingSecurityScopedResource()
            }
            
            parent.selectedURL = url
        }
        
        func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
            parent.selectedURL = nil
        }
    }
}
