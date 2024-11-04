//
//  PlayerView.swift
//  iPTV
//
//  Created by Gaurav Kumar on 10/25/24.
//

import SwiftUI
import GoogleCast
import AVKit

struct PlayerView: View {
    let streamURL: URL
    @State private var player: AVPlayer?
    
    var body: some View {
          VStack {
              if isCastingActive {
                  Text("Casting to TV...")
                      .font(.headline)
                      .padding()
              } else {
                  // Local player for playback
                  VideoPlayer(player: player)
                      .onAppear {
                          setupPlayer()
                      }
              }
          }
          .onAppear {
              startPlayback()
          }
      }
    
    private func startPlayback() {
           if isCastingActive {
               // Play via Chromecast
               startCasting()
           } else {
               // Play locally if not casting
               setupPlayer()
           }
       }
    
    private func startCasting() {
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
    
    private var isCastingActive: Bool {
            return GCKCastContext.sharedInstance().sessionManager.hasConnectedSession()
        }

        private func setupPlayer() {
            player = AVPlayer(url: streamURL)
            player?.play()
        }
    
//    func makeUIViewController(context: Context) -> AVPlayerViewController {
//        let player = AVPlayer(url: streamURL)
//        let controller = AVPlayerViewController()
//        controller.player = player
//        player.play()
//        return controller
//    }
//    
//    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {}
    
   
}

#Preview {
    PlayerView(streamURL: URL(fileURLWithPath: ""))
}
