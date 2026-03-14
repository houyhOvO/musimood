//
//  Playlist.swift
//  Musimood
//
//  Created by Yaohui Hou on 2026/3/14.
//

import SwiftData
import Foundation

@Model
class Playlist {
    var name: String
    
    @Relationship(deleteRule: .cascade)
    var songs: [Song] = []
    
    init(name: String) {
        self.name = name
    }
}
