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
                    .onDisappear{
                        player?.pause()
                    }
                
    // Cast and AirPlay Buttons
               HStack {
                   // Cast Button
                   Button(action: {
                       // Implement Google Cast functionality here
                       presentGoogleCast()
                   }) {
                       Image(systemName: "tv.fill")
                           .resizable()
                           .frame(width: 30, height: 30)
                           .foregroundColor(.blue)
                   }

                   Spacer()

                   // AirPlay Button
                   AirPlayButton()
                       .frame(width: 30, height: 30)
               }
               .padding()
            }
        }
        .sheet(isPresented: $showPurchaseView) {
            PurchaseView(purchaseManager: purchaseManager, isPresented: $showPurchaseView)
        }
        .onAppear {
            startPlayback()
        }
        
        
    }
    
    private func presentGoogleCast() {
            // Ensure Google Cast setup is initialized and the button is configured
            GCKCastContext.sharedInstance().presentCastDialog()
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

struct AirPlayButton: UIViewRepresentable {
    func makeUIView(context: Context) -> AVRoutePickerView {
        let airPlayButton = AVRoutePickerView()
        airPlayButton.activeTintColor = .blue
        airPlayButton.tintColor = .gray
        return airPlayButton
    }

    func updateUIView(_ uiView: AVRoutePickerView, context: Context) {}
}
