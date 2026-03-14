//
//  musimoodApp.swift
//  musimood
//
//  Created by Yaohui Hou on 2026/3/13.
//

import SwiftUI
import SwiftData

@main
struct MusimoodApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [Playlist.self, Song.self])
    }
}
