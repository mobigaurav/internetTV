//
//  CastPlayerView.swift
//  iPTV
//
//  Created by Gaurav Kumar on 11/1/24.
//

import SwiftUI
import AVKit
import MediaPlayer
import GoogleCast

struct CastPlayerView: View {
    let streamURL: URL
    @State private var player: AVPlayer?

    var body: some View {
        VStack {
            // Google Cast Button
            HStack {
                CastButton()
                    .frame(width: 44, height: 44)
                
                // AirPlay Button
                MPVolumeViewWrapper()
                    .frame(width: 44, height: 44)
            }
            .padding()

            // Video Player
            VideoPlayer(player: player)
                .onAppear {
                    setupPlayer()
                    startCastingIfAvailable()
                }
        }
    }

    private func setupPlayer() {
        player = AVPlayer(url: streamURL)
    }

    private func startCastingIfAvailable() {
        guard GCKCastContext.sharedInstance().sessionManager.hasConnectedSession() else {
            return
        }
        
        let mediaMetadata = GCKMediaMetadata()
        mediaMetadata.setString("Streaming Content", forKey: kGCKMetadataKeyTitle)

        let mediaInformation = GCKMediaInformation(
            contentID: streamURL.absoluteString,
            streamType: .buffered,
            contentType: "video/mp4",
            metadata: mediaMetadata,
            streamDuration: 0,
            mediaTracks: nil,
            textTrackStyle: nil,
            customData: nil
        )
        
        if let remoteMediaClient = GCKCastContext.sharedInstance().sessionManager.currentCastSession?.remoteMediaClient {
            remoteMediaClient.loadMedia(mediaInformation)
        }
    }
}


#Preview {
    CastPlayerView(streamURL: URL(string: "https://google.com")!)
}
