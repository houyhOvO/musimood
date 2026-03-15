//
//  PlaylistsView.swift
//  Musimood
//
//  Created by Yaohui Hou on 2026/3/13.
//

import SwiftUI
import SwiftData


struct PlaylistsView: View {
    @Query(sort: \Playlist.sortOrder) private var playlists: [Playlist]
    @Environment(\.modelContext) private var context
    
    @State private var isShowingAddSheet = false
    @State private var newPlaylistTitle = ""
    @State private var isEditing = false
    
    @State private var playlistBeingRenamed: Playlist? = nil
    @State private var renamedTitle: String = ""
    
    var body: some View {
        List {
            ForEach(playlists) { playlist in
                NavigationLink {
                    SongsView(playlist: playlist)
                } label: {
                    HStack {
                        playlist.artworkImage
                            .resizable()
                            .scaledToFill()
                            .frame(width: 40, height: 40)
                            .clipShape(RoundedRectangle(cornerRadius: 6))
                        
                        Text(playlist.name)
                            .font(.headline)
                    }
                }
                .swipeActions(edge: .trailing) {
                    Button(role: .destructive) {
                        context.delete(playlist)
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                    
                    Button {
                        playlistBeingRenamed = playlist
                        renamedTitle = playlist.name
                    } label: {
                        Label("Edit", systemImage: "pencil")
                    }
                    .tint(.blue)
                }
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
            PlaylistSheet(
                title: $newPlaylistTitle,
                onSave: { data in
                    let nextSortOrder = (playlists.map(\.sortOrder).max() ?? -1) + 1
                    let playlist = Playlist(name: newPlaylistTitle, artworkData: data, sortOrder: nextSortOrder)
                    context.insert(playlist)
                    newPlaylistTitle = ""
                }
            )
            .presentationDetents([.large])
        }
        .sheet(item: $playlistBeingRenamed) { playlist in
            PlaylistSheet(
                title: $renamedTitle,
                onSave: { data in
                    playlist.name = renamedTitle
                    if let data = data {
                        playlist.artworkData = data
                    }
                },
                sheetTitle: "Rename Playlist"
            )
        }
    }
    
    private func deletePlaylist(at offsets: IndexSet) {
        for index in offsets {
            context.delete(playlists[index])
        }
    }
    
    private func movePlaylist(from source: IndexSet, to destination: Int) {
        var reordered = playlists
        reordered.move(fromOffsets: source, toOffset: destination)
        
        for (index, playlist) in reordered.enumerated() {
            playlist.sortOrder = index
        }
    }
}
