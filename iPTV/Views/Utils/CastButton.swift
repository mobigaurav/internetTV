//
//  CastButton.swift
//  iPTV
//
//  Created by Gaurav Kumar on 11/1/24.
//

import SwiftUI
import GoogleCast

struct CastButton: UIViewRepresentable {
    var onCastButtonTapped: (() -> Void)?
    
    func makeUIView(context: Context) -> GCKUICastButton {
       let castButton = GCKUICastButton()
       castButton.tintColor = .red  // Customize as desired
       return castButton
    }
    
    func updateUIView(_ uiView: GCKUICastButton, context: Context) {
        
    }
    
    func makeCoordinator() -> Coordinator {
            Coordinator(self)
    }

    class Coordinator: NSObject {
        var parent: CastButton

        init(_ parent: CastButton) {
            self.parent = parent
        }

        @objc func castButtonTapped() {
            parent.onCastButtonTapped?()
        }
    }
}
