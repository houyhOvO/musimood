//
//  AudioImporter.swift
//  Musimood
//
//  Created by Yaohui Hou on 2026/3/14.
//


import SwiftUI
import UniformTypeIdentifiers

struct AudioImporter: UIViewControllerRepresentable {
    @Binding var selectedURL: URL?

    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        let types: [UTType] = [UTType.mp3, UTType.mpeg4Audio, UTType.wav]
        let picker = UIDocumentPickerViewController(forOpeningContentTypes: types, asCopy: true)
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UIDocumentPickerDelegate {
        let parent: AudioImporter
        init(_ parent: AudioImporter) { self.parent = parent }

        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            guard let url = urls.first else { return }

            // Support mp3, m4a and wav
            let allowedExtensions = ["mp3", "m4a", "wav"]
            guard allowedExtensions.contains(url.pathExtension.lowercased()) else {
                print("Unsupported audio file type:", url.pathExtension)
                return
            }
            let filename = url.lastPathComponent
            let destURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                .appendingPathComponent(filename)

            do {
                if FileManager.default.fileExists(atPath: destURL.path) {
                    try FileManager.default.removeItem(at: destURL)
                }
                try FileManager.default.copyItem(at: url, to: destURL)
                parent.selectedURL = destURL
                print("Imported audio to:", destURL)
            } catch {
                print("Failed to copy audio file: \(error.localizedDescription)")
            }
        }

        func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
            parent.selectedURL = nil
        }
    }
}
