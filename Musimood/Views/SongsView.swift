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
    
    @State private var songBeingEdited: Song? = nil
    @State private var editedTitle: String = ""
    @State private var editedArtist: String = ""
    
    @State private var showingAudioImporter = false
    @State private var importedAudioURL: URL? = nil
    @ObservedObject private var audioPlayer = AudioPlayer.shared
    
    @Query(sort: \Song.title, order: .forward) private var allSongs: [Song]
    
    var body: some View {
        List {
            ForEach(allSongs.filter { $0.playlist == playlist }) { song in
                VStack(alignment: .leading) {
                    Text(song.title)
                        .font(.headline)
                    
                    Text(song.artist)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    if let url = song.audioFileURL {
                        audioPlayer.play(url: url)
                    }
                }
                .swipeActions(edge: .trailing) {
                    Button(role: .destructive) {
                        context.delete(song)
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                    
                    Button {
                        songBeingEdited = song
                        editedTitle = song.title
                        editedArtist = song.artist
                    } label: {
                        Label("Edit", systemImage: "pencil")
                    }
                    .tint(.blue)
                }
            }
            .onDelete(perform: deleteSong)
            .onMove(perform: moveSong)
        }
        .environment(\.editMode, isEditing ? .constant(.active) : .constant(.inactive))
        .navigationTitle(playlist.name)
        
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    withAnimation(.spring()) {
                        isEditing.toggle()
                    }
                } label: {
                    Label(isEditing ? "Done" : "Edit",
                          systemImage: isEditing ? "checkmark" : "pencil")
                }
            }
            ToolbarItem(placement: .topBarTrailing) {
                Menu {
                    Button {
                        showingAudioImporter = true
                    } label: {
                        Label("Import", systemImage: "square.and.arrow.down")
                    }
                    
                } label: {
                    Image(systemName: "ellipsis")
                        .font(.title2)
                }
            }
        }
        .sheet(item: $songBeingEdited) { song in
            SongEditSheet(
                title: $editedTitle,
                artist: $editedArtist,
                sheetTitle: "Edit Song",
                onSave: {
                    song.title = editedTitle
                    song.artist = editedArtist
                }
            )
        }
        .sheet(isPresented: $showingAudioImporter) {
            AudioImporter(selectedURL: $importedAudioURL)
        }
        .onChange(of: importedAudioURL) { oldURL, newURL in
            guard let url = newURL else { return }
            let newSong = Song(
                title: url.deletingPathExtension().lastPathComponent,
                artist: "Unknown",
                playlist: playlist,
                audioFileName: url.lastPathComponent
            )
            context.insert(newSong)
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
}
