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
    
    init(name: String) {
        self.name = name
    }
}
