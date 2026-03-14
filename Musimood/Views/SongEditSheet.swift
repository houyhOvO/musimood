//
//  SongEditSheet.swift
//  Musimood
//
//  Created by Yaohui Hou on 2026/3/14.
//


import SwiftUI
import SwiftData

struct SongEditSheet: View {
    @Binding var title: String
    @Binding var artist: String
    var sheetTitle: String = "Edit Song"
    var onSave: () -> Void
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    VStack(spacing: 12) {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(.quaternary)
                            .frame(width: 120, height: 120)
                            .overlay {
                                Image(systemName: "music.note")
                                    .font(.system(size: 40))
                                    .foregroundStyle(.secondary)
                            }
                        
                        Text("Add Artwork")
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity)
                    .listRowBackground(Color.clear)
                }
                
                Section {
                    TextField("Song Title", text: $title)
                    TextField("Artist", text: $artist)
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
                        onSave()
                        dismiss()
                    } label: {
                        Image(systemName: "checkmark")
                    }
                    .buttonStyle(.glassProminent)
                    .disabled(title.trimmingCharacters(in: .whitespaces).isEmpty ||
                              artist.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
        }
    }
}
