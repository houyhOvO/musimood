//
//  AudioPlayer.swift
//  Musimood
//
//  Created by Yaohui Hou on 2026/3/14.
//


import Foundation
import AVFoundation
import MediaPlayer
import Combine
import SwiftUI


class AudioPlayer: ObservableObject {
    static let shared = AudioPlayer()
    
    @Published var isPlaying = false
    @Published var currentSong: Song? = nil
    
    private var player: AVAudioPlayer?
    
    private init() {
        setupAudioSession()
    }
    
    private func setupAudioSession() {
        do {
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(.playback, mode: .default, options: [])
            try session.setActive(true)
        } catch {
            print("Audio session setup failed: \(error.localizedDescription)")
        }
    }
    
    func play(song: Song) {
        guard let url = song.audioFileURL else {
            print("Audio file URL not found for song: \(song.title)")
            return
        }
        currentSong = song
        play(url: url, title: song.title, artist: song.artist)
    }
    
    private func play(url: URL, title: String, artist: String) {
        stop()
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.prepareToPlay()
            player?.play()
            isPlaying = true
            updateNowPlayingInfo(title: title, artist: artist)
        } catch {
            print("Failed to play audio: \(error.localizedDescription)")
        }
    }
    
    func stop() {
        player?.stop()
        player = nil
        isPlaying = false
        currentSong = nil
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nil
    }
    
    private func updateNowPlayingInfo(title: String, artist: String) {
        var nowPlayingInfo: [String: Any] = [
            MPMediaItemPropertyTitle: title,
            MPMediaItemPropertyArtist: artist
        ]
        
        if let artworkURL = currentSong?.artworkFileURL,
           let image = UIImage(contentsOfFile: artworkURL.path) {
            let artwork = MPMediaItemArtwork(boundsSize: image.size) { _ in image }
            nowPlayingInfo[MPMediaItemPropertyArtwork] = artwork
        }
        
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
    }
}

extension Song {
    var artworkFileURL: URL? {
        guard let artworkName = audioFileName else { return nil }
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            .first?.appendingPathComponent(artworkName)
    }
}
