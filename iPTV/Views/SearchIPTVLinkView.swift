//
//  SearchIPTVLinkView.swift
//  iPTV
//
//  Created by Gaurav Kumar on 11/4/24.
//

import SwiftUI

import SwiftUI

struct SearchIPTVLinkView: View {
    @State private var iptvLink: String = ""
    @State private var channels: [ChannelInfo] = []
    @State private var isLoading = false
    @State private var selectedChannel: ChannelInfo?
    @State private var selectedStreamUrl:IdentifiableURL?
    @EnvironmentObject var favoritesManager: FavoritesManager
    @ObservedObject var purchaseManager: PurchaseManager
    
    func toggleFavorite(_ channel: ChannelInfo) {
           if favoritesManager.isFavorite(channel) {
               favoritesManager.removeFromFavorites(channel)
           } else {
               favoritesManager.addToFavorites(channel)
           }
       }
    
    var body: some View {
        NavigationView {
            VStack {
                // Search bar for IPTV link
                TextField("Enter IPTV link...", text: $iptvLink, onCommit: fetchChannels)
                    .padding(10)
                    .background(Color(.systemGray5))
                    .cornerRadius(8)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding([.horizontal, .top])
                    .keyboardType(.URL)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                
                if isLoading {
                    ProgressView("Loading channels...")
                        .padding()
                } else {
                    List(channels, id: \.id) { channel in
                            HStack {
                                ChannelImageView(url: channel.logoURL)
                                Text(channel.name)
                                    .font(.headline)
                                    .foregroundColor(.primary)
                                Spacer()
                                Button(action: {
                                            toggleFavorite(channel)
                                        }) {
                                            Image(systemName: favoritesManager.isFavorite(channel) ? "heart.fill" : "heart")
                                                .foregroundColor(.red)
                                        }
                                        .buttonStyle(PlainButtonStyle()) 
                            }
                            .padding()
                            .background(Color.white)
                            .cornerRadius(12)
                            .shadow(radius: 4)
                            .onTapGesture {
                                selectedStreamUrl = IdentifiableURL(url:channel.url)
                            }
                    }
                }
            }
            .navigationTitle("Stream")
            .sheet(item: $selectedStreamUrl) { channel in
                PlayerView(streamURL: channel.url, purchaseManager: purchaseManager)
            }
        }
    }

    private func fetchChannels() {
        guard let url = URL(string: iptvLink) else { return }
        isLoading = true
        URLSession.shared.dataTask(with: url) { data, response, error in
            defer { isLoading = false }
            guard let data = data, error == nil else { return }
            if let dataString = String(data: data, encoding: .utf8) {
                DispatchQueue.global(qos: .userInitiated).async {
                    let parsedChannels = M3UParser.parse(dataString)
                    DispatchQueue.main.async {
                        self.channels = parsedChannels
                        self.iptvLink = ""
                    }
                }
            }
        }.resume()
    }
}


//#Preview {
//    SearchIPTVLinkView()
//}
