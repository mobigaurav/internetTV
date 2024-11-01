//
//  PlayerView.swift
//  iPTV
//
//  Created by Gaurav Kumar on 10/25/24.
//

import SwiftUI
import AVKit

struct PlayerView: UIViewControllerRepresentable {
    let streamURL: URL
    
    func makeUIViewController(context: Context) -> AVPlayerViewController {
        let player = AVPlayer(url: streamURL)
        let controller = AVPlayerViewController()
        controller.player = player
        player.play()
        return controller
    }
    
    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {}
    
   
}

#Preview {
    PlayerView(streamURL: URL(fileURLWithPath: ""))
}
