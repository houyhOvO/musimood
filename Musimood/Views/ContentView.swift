//
//  ContentView.swift
//  musimood
//
//  Created by Yaohui Hou on 2026/3/13.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack(alignment: .bottom){
            TabView {                
                NavigationStack {
                    PlaylistsView()
                        .navigationTitle("Playlists")
                }
                .tabItem {
                    Label("Playlists", systemImage: "music.note.list")
                }
                
                NavigationStack {
                    SettingsView()
                        .navigationTitle("Settings")
                }
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
                
            }
            
            PlayerBar()
                .padding(.horizontal)
                .padding(.bottom, 60)
            
        }
    }
}
