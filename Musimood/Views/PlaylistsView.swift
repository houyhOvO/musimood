//
//  PlaylistsView.swift
//  Musimood
//
//  Created by Yaohui Hou on 2026/3/13.
//

import SwiftUI
import SwiftData


struct PlaylistsView: View {
    @Query private var playlists: [Playlist]
    @Environment(\.modelContext) private var context
    
    @State private var isShowingAddSheet = false
    @State private var newPlaylistTitle = ""
    @State private var isEditing = false
    @Environment(\.dismiss) private var dismiss

    
    var body: some View {
        List {
            ForEach(playlists) { playlist in
                Text(playlist.name)
            }
            .onDelete(perform: deletePlaylist)
            .onMove(perform: movePlaylist)
        }
        .environment(\.editMode, isEditing ? .constant(.active) : .constant(.inactive))
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button(isEditing ? "Done" : "Edit") {
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
                        isEditing.toggle()
                    }
                }
                .contentTransition(.identity)
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    isShowingAddSheet = true
                } label: {
                    Image(systemName: "plus")
                }
            }
        }

        .sheet(isPresented: $isShowingAddSheet) {
            NewPlaylistSheet(
                title: $newPlaylistTitle,
                onSave: {
                    if !newPlaylistTitle.isEmpty {
//                        playlists.append(Playlist(name: newPlaylistTitle))
                        context.insert(Playlist(name: newPlaylistTitle))
                        newPlaylistTitle = ""
                    }
                }
            )
        .presentationDetents([.large])
        }
    }
    
    private func deletePlaylist(at offsets: IndexSet) {
//        playlists.remove(atOffsets: offsets)
        for index in offsets {
                context.delete(playlists[index])
            }
    }
    
    private func movePlaylist(from source: IndexSet, to destination: Int) {
//        playlists.move(fromOffsets: source, toOffset: destination)
        var reordered = playlists
            reordered.move(fromOffsets: source, toOffset: destination)
    }
}

//struct Playlist: Identifiable {
//    let id = UUID()
//    var name: String
//}

struct NewPlaylistSheet: View {
    @Binding var title: String
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
                                Image(systemName: "music.note.list")
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
                    TextField("Playlist Name", text: $title)
                        .font(.title3)
                        .multilineTextAlignment(.center)
                }
            }
            .navigationTitle("New Playlist")
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
                    .disabled(title.isEmpty)
                }
            }
        }
    }
}
