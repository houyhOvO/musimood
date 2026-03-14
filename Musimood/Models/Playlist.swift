//
//  Playlist.swift
//  Musimood
//
//  Created by Yaohui Hou on 2026/3/14.
//

import SwiftData
import SwiftUI
import Foundation

@Model
class Playlist {
    var name: String
    var artworkData: Data?
    var sortOrder: Int
    
    @Relationship(deleteRule: .cascade)
    var songs: [Song] = []
    
    init(name: String, artworkData: Data? = nil, sortOrder: Int = 0) {
        self.name = name
        self.artworkData = artworkData
        self.sortOrder = sortOrder
    }
    
    var artworkImage: Image {
        if let data = artworkData, let uiImage = UIImage(data: data) {
            return Image(uiImage: uiImage)
        } else {
            return Image(systemName: "music.note.list")
        }
    }
}
