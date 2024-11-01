//
//  ChannelListViewTwo.swift
//  iPTV
//
//  Created by Gaurav Kumar on 10/31/24.
//

import SwiftUI

struct ChannelListView: View {
    let filterType: FilterType
    @State private var filteredChannels: [ChannelInfo] = []
    @State private var isLoading = true
    @State private var selectedStreamUrl:IdentifiableURL?
    @EnvironmentObject var favoritesManager: FavoritesManager
    
    var body: some View {
        VStack {
            if isLoading {
                ProgressView("Loading Channels...")
                    .padding()
            } else {
                List(filteredChannels, id: \.url) { channel in
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
        .navigationTitle(filterType.displayName)
        .onAppear(perform: loadChannels)
        .sheet(item: $selectedStreamUrl) {streamUrl in
            PlayerView(streamURL: streamUrl.url)
            
        }
    }
    
    func toggleFavorite(_ channel: ChannelInfo) {
           if favoritesManager.isFavorite(channel) {
               favoritesManager.removeFromFavorites(channel)
           } else {
               favoritesManager.addToFavorites(channel)
           }
       }
    
    private func loadChannels() {
        guard let url = filterType.m3uURL else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else { return }
            if let dataString = String(data: data, encoding: .utf8) {
                let parsedChannels = M3UParser.parse(dataString)
                
                // Filter channels by groupTitle based on filter type
                let channels = parsedChannels.filter { channel in
                    switch filterType {
                    case .category(let value), .language(let value), .region(let value), .country(let value):
                        return channel.groupTitle == value
                    }
                }
                
                DispatchQueue.main.async {
                    self.filteredChannels = channels
                    self.isLoading = false
                }
            }
        }.resume()
    }
}

