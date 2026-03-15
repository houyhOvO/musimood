//
//  FullPlayerView.swift
//  Musimood
//
//  Created by Yaohui Hou on 2026/3/14.
//


import SwiftUI

struct FullPlayerView: View {

    @ObservedObject var player = AudioPlayer.shared
    
    @Environment(\.dismiss) var dismiss

    var body: some View {

        if let song = player.currentSong {

            VStack(spacing: 40) {
                HStack {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.down")
                            .font(.title2)
                    }

                    Spacer()
                }
                .padding()

                Spacer()

                VStack(spacing: 8) {
                    Text(song.title)
                        .font(.title2)
                        .fontWeight(.bold)

                    Text(song.artist)
                        .foregroundStyle(.secondary)
                }

                VStack {
                    Slider(
                        value: Binding(
                            get: { player.currentTime },
                            set: { player.seek(to: $0) }
                        ),
                        in: 0...max(player.duration, 1)
                    )

                    HStack {
                        Text(formatTime(player.currentTime))
                        Spacer()
                        Text(formatTime(player.duration))
                    }
                    .font(.caption)
                    .foregroundStyle(.secondary)

                }
                .padding(.horizontal)

                HStack(spacing: 50) {
                    Button {
                        player.seek(to: player.currentTime - 10)
                    } label: {
                        Image(systemName: "gobackward.10")
                            .font(.title)
                    }

                    Button {
                        if player.isPlaying {
                            player.pause()
                        } else {
                            player.resume()
                        }
                    } label: {
                        Image(systemName: player.isPlaying ? "pause.circle.fill" : "play.circle.fill")
                            .font(.system(size: 70))
                    }

                    Button {
                        player.seek(to: player.currentTime + 10)
                    } label: {
                        Image(systemName: "goforward.10")
                            .font(.title)
                    }

                }

                Spacer()

            }
            .background(.ultraThinMaterial)
        }
    }

    func formatTime(_ time: TimeInterval) -> String {
        let m = Int(time) / 60
        let s = Int(time) % 60
        return String(format: "%d:%02d", m, s)
    }
}
