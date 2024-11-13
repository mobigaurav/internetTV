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
    @EnvironmentObject var historyManager:HistoryManager
    @State private var showBrowser = false
    @State private var showPurchaseView = false
    @EnvironmentObject var streamManager: StreamManager
    
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
                HStack {
                    TextField("Enter Any IPTV link...", text: $iptvLink, onCommit: fetchChannels)
                        .padding(10)
                        .background(Color(.systemGray5))
                        .cornerRadius(8)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding([.horizontal, .top])
                        .keyboardType(.URL)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                        .frame(maxWidth: .infinity)
                        .onChange(of:streamManager.currentLink) {newLink in
                            if let newLink = newLink {
                                iptvLink = newLink
                                fetchChannels()
                            }
                            
                        }
                    
                    Button(action: {
                        showBrowser = true
                    }) {
                        Image(systemName: "globe")
                            .resizable()
                            .frame(width: 24, height: 24)
                            .padding(.horizontal, 5)
                    }
                    .sheet(isPresented: $showBrowser) {
                        InAppBrowserView(url: URL(string: "https://www.google.com")!)
                    }
                    
                }
        
                
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
                                if purchaseManager.isPurchased {
                                    showPurchaseView = false
                                    toggleFavorite(channel)
                                }else {
                                    showPurchaseView = true
                                }
                                
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
            .navigationBarItems(trailing: HStack(spacing:16) {
                CastButton()
                    .frame(width:35, height: 35)
                MPVolumeViewWrapper()
                    .frame(width:35, height: 35)
            })
            .sheet(isPresented: $showPurchaseView) {
                           PurchaseView(purchaseManager: purchaseManager, isPresented: $showPurchaseView)
                       }
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
                        historyManager.addLink(iptvLink)
                        self.iptvLink = ""
                    }
                }
            }
        }.resume()
    }
}


//#Preview {
//    var purchaseManager:PurchaseManager
//    SearchIPTVLinkView(purchaseManager: purchaseManager)
//}
