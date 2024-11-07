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
    @State private var showPurchaseView = false
    @ObservedObject var purchaseManager: PurchaseManager
    
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
        .sheet(isPresented: $showPurchaseView) {
            PurchaseView(purchaseManager: purchaseManager, isPresented: $showPurchaseView)
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
        if !purchaseManager.isPurchased {
            showPurchaseView = true
        }else {
            showPurchaseView = false
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
    
    private var isCastingActive: Bool {
       
        return GCKCastContext.sharedInstance().sessionManager.hasConnectedSession()
    }
    
    private func setupPlayer() {
        player = AVPlayer(url: streamURL)
        player?.play()
    }
}
