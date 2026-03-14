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

class AudioPlayer: ObservableObject {
    
    static let shared = AudioPlayer()
    
    @Published var isPlaying = false
    @Published var currentSong: Song? = nil
    @Published var currentTime: TimeInterval = 0
    @Published var duration: TimeInterval = 0
    
    private var player: AVAudioPlayer?
    private var timer: Timer?
    
    private init() {
        setupAudioSession()
    }
    
    // MARK: Audio Session
    
    private func setupAudioSession() {
        do {
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(.playback, mode: .default)
            try session.setActive(true)
        } catch {
            print("AudioSession error:", error)
        }
    }
    
    // MARK: Play
    
    func play(song: Song) {
        guard let url = song.audioFileURL else { return }
        
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.prepareToPlay()
            player?.play()
            
            currentSong = song
            isPlaying = true
            duration = player?.duration ?? 0
            
            startTimer()
            updateNowPlaying(song: song)
            
        } catch {
            print("Play error:", error)
        }
    }
    
    // MARK: Pause
    
    func pause() {
        player?.pause()
        isPlaying = false
    }
    
    // MARK: Resume
    
    func resume() {
        player?.play()
        isPlaying = true
    }
    
    // MARK: Stop
    
    func stop() {
        player?.stop()
        player = nil
        
        timer?.invalidate()
        timer = nil
        
        isPlaying = false
        currentTime = 0
        duration = 0
        
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nil
    }
    
    // MARK: Seek
    
    func seek(to time: TimeInterval) {
        player?.currentTime = time
        currentTime = time
    }
    
    // MARK: Timer
    
    private func startTimer() {
        
        timer?.invalidate()
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { _ in
            
            guard let player = self.player else { return }
            
            DispatchQueue.main.async {
                self.currentTime = player.currentTime
            }
        }
    }
    
    // MARK: Lock Screen
    
    private func updateNowPlaying(song: Song) {
        
        var info: [String: Any] = [
            MPMediaItemPropertyTitle: song.title,
            MPMediaItemPropertyArtist: song.artist
        ]
        
        if let duration = player?.duration {
            info[MPMediaItemPropertyPlaybackDuration] = duration
        }
        
        MPNowPlayingInfoCenter.default().nowPlayingInfo = info
    }
}
