//
//  FavoritesView.swift
//  iPTV
//
//  Created by Gaurav Kumar on 10/30/24.
//

import SwiftUI

struct FavoritesView: View {
    @EnvironmentObject var favoritesManager: FavoritesManager
    @State private var selectedStreamUrl: IdentifiableURL?
    
    var body: some View {
        NavigationView {
            if favoritesManager.favoriteChannels.isEmpty {
                Text("No favorites yet")
                    .foregroundColor(.gray)
                    .font(.headline)
                    .padding()
            } else {
                
                List(favoritesManager.favoriteChannels) { channel in
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
//        .onAppear{
//            favoritesManager.l
//        }
        .navigationTitle("Favorites")
        .sheet(item: $selectedStreamUrl) { identifiableURL in
            PlayerView(streamURL: identifiableURL.url)
            
        }
    }
    
    func toggleFavorite(_ channel: ChannelInfo) {
           if favoritesManager.isFavorite(channel) {
               favoritesManager.removeFromFavorites(channel)
           } else {
               favoritesManager.addToFavorites(channel)
           }
       }
}



//#Preview {
//    FavoritesView()
//}