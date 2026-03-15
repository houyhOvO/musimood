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
    @Published var currentSong: Song?
    @Published var currentTime: TimeInterval = 0
    @Published var duration: TimeInterval = 0
    
    private var player: AVAudioPlayer?
    private var timer: Timer?
    
    private init() {
        setupAudioSession()
        setupRemoteCommands()
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
    
    // MARK: Remote Command
    
    private func setupRemoteCommands() {
        
        let commandCenter = MPRemoteCommandCenter.shared()
        
        commandCenter.playCommand.addTarget { [weak self] _ in
            self?.resume()
            return .success
        }
        
        commandCenter.pauseCommand.addTarget { [weak self] _ in
            self?.pause()
            return .success
        }
        
        commandCenter.changePlaybackPositionCommand.addTarget { [weak self] event in
            
            guard let event = event as? MPChangePlaybackPositionCommandEvent else {
                return .commandFailed
            }
            
            self?.seek(to: event.positionTime)
            return .success
        }
    }
    
    // MARK: Play
    
    func play(song: Song) {
        
//        guard let url = song.audioFileURL else { return }
        guard let url = song.audioFileURL, FileManager.default.fileExists(atPath: url.path) else {
            print("Audio file not found:", song.audioFileURL?.absoluteString ?? "nil")
            return
        }
        
        let allowedExtensions = ["mp3", "m4a", "wav"]
        guard allowedExtensions.contains(url.pathExtension.lowercased()) else {
            print("Unsupported audio file format:", url.pathExtension)
            return
        }
        
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.prepareToPlay()
            player?.play()
            
            currentSong = song
            isPlaying = true
            duration = player?.duration ?? 0
            
            startTimer()
            updateNowPlaying()
            
        } catch {
            print("Play error:", error.localizedDescription)
        }
    }
    
    // MARK: Pause
    
    func pause() {
        player?.pause()
        isPlaying = false
        updateNowPlaying()
    }
    
    // MARK: Resume
    
    func resume() {
        player?.play()
        isPlaying = true
        updateNowPlaying()
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
        updateNowPlaying()
    }
    
    // MARK: Timer
    
    private func startTimer() {
        
        timer?.invalidate()
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { _ in
            
            guard let player = self.player else { return }
            
            DispatchQueue.main.async {
                self.currentTime = player.currentTime
                self.updateNowPlaying()
            }
        }
    }
    
    // MARK: Lock Screen Info
    
    private func updateNowPlaying() {
        
        guard let song = currentSong else { return }
        
        let info: [String: Any] = [
            MPMediaItemPropertyTitle: song.title,
            MPMediaItemPropertyArtist: song.artist,
            MPNowPlayingInfoPropertyElapsedPlaybackTime: currentTime,
            MPMediaItemPropertyPlaybackDuration: duration,
            MPNowPlayingInfoPropertyPlaybackRate: isPlaying ? 1 : 0
        ]
        
        MPNowPlayingInfoCenter.default().nowPlayingInfo = info
    }
}
