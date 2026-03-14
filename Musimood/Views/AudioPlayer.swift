//
//  AudioPlayer.swift
//  Musimood
//
//  Created by Yaohui Hou on 2026/3/14.
//


import Foundation
import AVFoundation
import SwiftUI
internal import Combine

class AudioPlayer: ObservableObject {
    static let shared = AudioPlayer()
    @Published var isPlaying = false

    private var player: AVAudioPlayer?

    func play(url: URL) {
        stop()
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.play()
            isPlaying = true
        } catch {
            print("Failed to play audio: \(error)")
        }
    }

    func stop() {
        player?.stop()
        player = nil
        isPlaying = false
    }
}
