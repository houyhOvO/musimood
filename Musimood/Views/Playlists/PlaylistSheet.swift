//
//  PlaylistSheet.swift
//  Musimood
//
//  Created by Yaohui Hou on 2026/3/14.
//

import PhotosUI
import SwiftUI

struct PlaylistSheet: View {
    @Binding var title: String
    var onSave: (Data?) -> Void
    var sheetTitle: String = "New Playlist"
    @Environment(\.dismiss) private var dismiss
    
    @State private var selectedImage: UIImage? = nil
    @State private var showingImagePicker = false
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    VStack(spacing: 12) {
                        if let image = selectedImage {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 120, height: 120)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                        } else {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(.quaternary)
                                .frame(width: 120, height: 120)
                                .overlay {
                                    Image(systemName: "music.note.list")
                                        .font(.system(size: 40))
                                        .foregroundStyle(.secondary)
                                }
                        }
                        
                        Button("Select Cover") {
                            showingImagePicker = true
                        }
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity)
                    .listRowBackground(Color.clear)
                }
                
                Section {
                    TextField("Playlist Name", text: $title)
                        .font(.title3)
                        .multilineTextAlignment(.center)
                }
            }
            .navigationTitle(sheetTitle)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        let data = selectedImage?.jpegData(compressionQuality: 0.8)
                        onSave(data)
                        dismiss()
                    } label: {
                        Image(systemName: "checkmark")
                    }
                    .buttonStyle(.glassProminent)
                    .disabled(title.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
            .sheet(isPresented: $showingImagePicker) {
                ImagePicker(image: $selectedImage)
            }
        }
    }
}
