//
//  CustomAirPlayButton.swift
//  iPTV
//
//  Created by Gaurav Kumar on 11/1/24.
//

import SwiftUI
import AVKit

struct CustomAirPlayButton: View {
    var body: some View {
        Button(action: {
            // Show AirPlay route picker when tapped
            let routePickerView = AVRoutePickerView()
            routePickerView.tintColor = .blue  // Customize as needed
            
            // Find the key window to present the route picker from
            if let window = UIApplication.shared.windows.first {
                window.addSubview(routePickerView)
                
                // Programmatically trigger the AirPlay menu
                if let routePickerButton = routePickerView.subviews.first(where: { $0 is UIButton }) as? UIButton {
                    routePickerButton.sendActions(for: .touchUpInside)
                }
            }
            
            print("AirPlay button tapped")  // Log or perform other actions here
        }) {
            Image(systemName: "airplayaudio")
                .resizable()
                .frame(width: 24, height: 24)
                .foregroundColor(.blue)
        }
    }
}

