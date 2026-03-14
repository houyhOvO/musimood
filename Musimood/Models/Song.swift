//
//  Song.swift
//  Musimood
//
//  Created by Yaohui Hou on 2026/3/14.
//

import Foundation
import SwiftData

@Model
class Song {
    var title: String
    var artist: String
    var playlist: Playlist?
    
    init(title: String, artist: String, playlist: Playlist? = nil) {
        self.title = title
        self.artist = artist
        self.playlist = playlist
    }
}
