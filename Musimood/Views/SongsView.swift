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
    
    var body: some View {
        List {
            Text("Songs will appear here")
        }
        .navigationTitle(playlist.name)
    }
}
