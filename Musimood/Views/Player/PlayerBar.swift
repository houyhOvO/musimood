//
//  PlayerBar.swift
//  Musimood
//
//  Created by Yaohui Hou on 2026/3/14.
//


import SwiftUI


struct PlayerBar: View {

    @ObservedObject var player = AudioPlayer.shared
    @State private var showFullPlayer = false

    var body: some View {

        if let song = player.currentSong {

            HStack {
                VStack(alignment: .leading) {
                    Text(song.title)
                        .font(.headline)

                    Text(song.artist)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                Spacer()

                Button {
                    if player.isPlaying {
                        player.pause()
                    } else {
                        player.resume()
                    }
                } label: {
                    Image(systemName: player.isPlaying ? "pause.fill" : "play.fill")
                        .font(.title2)
                }

            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .glassEffect(.regular.interactive())
            .clipShape(
                RoundedRectangle(cornerRadius: 22, style: .continuous)
            )
            .padding(.horizontal)
            .onTapGesture {
                showFullPlayer = true
            }
            .fullScreenCover(isPresented: $showFullPlayer) {
                FullPlayerView()
            }
        }
    }
}
