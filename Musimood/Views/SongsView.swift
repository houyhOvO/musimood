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
    
    @Query(sort: \Song.title) private var allSongs: [Song]
    
    private var songsInPlaylist: [Song] {
        allSongs.filter { $0.playlist == playlist }
    }
    
    var body: some View {
        VStack (spacing: 0){
            List {
                ForEach(songsInPlaylist) { song in
                    SongRow(song: song)
                        .swipeActions(edge: .trailing) {
                            Button(role: .destructive) {
                                deleteSong(song)
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
                .onDelete(perform: deleteSongAtOffsets)
                .onMove(perform: moveSong)
            }
            PlayerBar()
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
                    Label(
                        isEditing ? "Done" : "Edit",
                        systemImage: isEditing ? "checkmark" : "pencil"
                    )
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
        
        // MARK: Edit Song Sheet
        
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
        
        // MARK: Import Audio
        
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
}

// MARK: - Song Row

struct SongRow: View {
    
    var song: Song
    
    @ObservedObject private var audioPlayer = AudioPlayer.shared
    
    var body: some View {
        VStack(alignment: .leading) {
            
            Text(song.title)
                .font(.headline)
            
            Text(song.artist)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .contentShape(Rectangle())
        .onTapGesture {
            audioPlayer.play(song: song)
        }
    }
}

// MARK: - Delete / Move

extension SongsView {
    
    private func deleteSong(_ song: Song) {
        
        if let url = song.audioFileURL {
            try? FileManager.default.removeItem(at: url)
        }
        
        context.delete(song)
    }
    
    private func deleteSongAtOffsets(_ offsets: IndexSet) {
        
        for index in offsets {
            let song = songsInPlaylist[index]
            deleteSong(song)
        }
    }
    
    private func moveSong(from source: IndexSet, to destination: Int) {
        playlist.songs.move(fromOffsets: source, toOffset: destination)
    }
}

struct PlayerBar: View {
    
    @ObservedObject var player = AudioPlayer.shared
    
    var body: some View {
        if let song = player.currentSong {
            VStack(spacing: 6) {
                HStack {
                    VStack(alignment: .leading) {
                        Text(song.title)
                            .font(.headline)
                        Text(song.artist)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }

                    Spacer()
                    
                    Button {
                        if player.isPlaying {
                            player.pause()
                        } else {
                            player.resume()
                        }
                    } label: {
                        Image(systemName: player.isPlaying ? "pause.fill" : "play.fill")
                            .font(.title2)
                    }
                }
                Slider(
                    value: Binding(
                        get: { player.currentTime },
                        set: { player.seek(to: $0) }
                    ),
                    in: 0...max(player.duration, 1)
                )
                
                HStack {
                    Text(formatTime(player.currentTime))
                        .font(.caption2)
                    Spacer()
                    Text(formatTime(player.duration))
                        .font(.caption2)
                }
            }
            .padding()
            .background(.ultraThinMaterial)
        }
    }
    
    func formatTime(_ time: TimeInterval) -> String {
        let m = Int(time) / 60
        let s = Int(time) % 60
        return String(format: "%d:%02d", m, s)
    }
}
