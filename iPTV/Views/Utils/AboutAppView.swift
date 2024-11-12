//
//  AboutAppView.swift
//  iPTV
//
//  Created by Gaurav Kumar on 11/4/24.
//

import SwiftUI

struct AboutAppView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("iStreamX - IPTV App")
                .font(.largeTitle)
                .padding(.bottom, 5)
            
            Text("Version: 1.0")
            Text("Developer: iStreamX")
            Text("This app allows users to stream IPTV content, manage favorites, and access a wide range of channels.")
            
            Spacer()
        }
        .padding()
       // .navigationTitle("About App")
    }
}

#Preview {
    AboutAppView()
}
