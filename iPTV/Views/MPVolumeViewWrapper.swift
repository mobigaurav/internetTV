//
//  MPVolumeViewWrapper.swift
//  iPTV
//
//  Created by Gaurav Kumar on 11/1/24.
//

import SwiftUI
import AVKit

struct MPVolumeViewWrapper: UIViewRepresentable {
    func makeUIView(context: Context) -> AVRoutePickerView {
        let routePickerView = AVRoutePickerView()
            routePickerView.activeTintColor = .blue  // Customize active state color
            routePickerView.tintColor = .blue  // Customize inactive state color
            routePickerView.prioritizesVideoDevices = false  // Use only for audio devices if needed
            return routePickerView
    }

    func updateUIView(_ uiView: AVRoutePickerView, context: Context) {}
}

