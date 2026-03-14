//
//  SongsView.swift
//  Musimood
//
//  Created by Yaohui Hou on 2026/3/14.
//

import SwiftUI
import SwiftData

struct SongsView: View {
    
    var playlist: Playlist
    
    @Environment(\.modelContext) private var context
    
    @State private var isEditing = false
    
    var body: some View {
        List {
            ForEach(playlist.songs) { song in
                VStack(alignment: .leading) {
                    Text(song.title)
                        .font(.headline)
                    
                    Text(song.artist)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
            .onDelete(perform: deleteSong)
            .onMove(perform: moveSong)
        }
        .environment(\.editMode, isEditing ? .constant(.active) : .constant(.inactive))
        .navigationTitle(playlist.name)
        
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Menu {
                    Button {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
                            isEditing.toggle()
                        }
                    } label: {
                        Label(isEditing ? "Done" : "Edit",
                              systemImage: isEditing ? "checkmark" : "pencil")
                    }
                    
                    Button {
                        importSong()
                    } label: {
                        Label("Import", systemImage: "square.and.arrow.down")
                    }
                    
                } label: {
                    Image(systemName: "ellipsis")
                        .font(.title2)
                }
            }
        }
    }
    
    private func deleteSong(at offsets: IndexSet) {
        for index in offsets {
            context.delete(playlist.songs[index])
        }
    }
    
    private func moveSong(from source: IndexSet, to destination: Int) {
        playlist.songs.move(fromOffsets: source, toOffset: destination)
    }
    
    private func importSong() {
        let newSong = Song(
            title: "New Song",
            artist: "Unknown",
            playlist: playlist
        )
        
        context.insert(newSong)
    }
}
