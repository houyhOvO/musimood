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
    @Attribute(.unique) var id: UUID = UUID()
    var title: String
    var artist: String
    var playlist: Playlist
    
    var audioFileName: String?
    
    init(title: String, artist: String, playlist: Playlist, audioFileName: String? = nil) {
        self.title = title
        self.artist = artist
        self.playlist = playlist
        self.audioFileName = audioFileName
    }
    
    var audioFileURL: URL? {
        guard let name = audioFileName else { return nil }
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent(name)
    }
}
