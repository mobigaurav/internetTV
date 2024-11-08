//
//  DashboardViewNew.swift
//  iPTV
//
//  Created by Gaurav Kumar on 10/31/24.
//

import SwiftUI
import Combine
import GoogleCast
import AVKit
import MediaPlayer

struct DashboardView: View {
    @State private var searchText = ""
    @State private var selectedStreamUrl:IdentifiableURL?
    @State private var isLoading = true
    @State private var cancellable: AnyCancellable?
    private let cacheKey = "DashboardData"
    @ObservedObject var viewModel = DashboardViewModel()
    @EnvironmentObject var favoritesManager: FavoritesManager
    @ObservedObject var purchaseManager: PurchaseManager
    @State private var showPurchaseView = false
    @State private var shouldNavigate = false
    
    var body: some View {
        NavigationView {
            VStack {
                if viewModel.isLoading {
                    // Show loading spinner while data is being fetched
                    ProgressView("Loading channels...")
                        .padding()
                }
                else {
                    // Search Bar
//                    TextField("Search channels...", text: $searchText)
//                        .padding(10)
//                        .background(Color(.systemGray5))
//                        .cornerRadius(8)
//                        .padding([.horizontal, .top])
//                        .onSubmit{
//                            self.applyFilters(searchText)
//                        }
                    // Horizontal Scrollable Buttons
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 15) {
                            // Navigate to Category List
                     
                            NavigationLink(destination: CategoryListView(purchaseManager: purchaseManager)) {
                                Text("Category")
                                    .padding(.vertical, 8)
                                    .padding(.horizontal, 12)
                                    .background(Color.blue)
                                    .foregroundColor(.white)
                                    .cornerRadius(15)
                            }
                           
                 
                            NavigationLink(destination: RegionListView(purchaseManager: purchaseManager)) {
                                Text("Regions")
                                    .padding(.vertical, 8)
                                    .padding(.horizontal, 12)
                                    .background(Color.blue)
                                    .foregroundColor(.white)
                                    .cornerRadius(15)
                            }
                         
                     
                            NavigationLink(destination: LanguageListView(purchaseManager: purchaseManager)) {
                                Text("Language")
                                    .padding(.vertical, 8)
                                    .padding(.horizontal, 12)
                                    .background(Color.blue)
                                    .foregroundColor(.white)
                                    .cornerRadius(15)
                            }
                         
                        
                            NavigationLink(destination: CountryListView(purchaseManager: purchaseManager)) {
                                Text("Countries")
                                    .padding(.vertical, 8)
                                    .padding(.horizontal, 12)
                                    .background(Color.blue)
                                    .foregroundColor(.white)
                                    .cornerRadius(15)
                            }
                        }
                        .padding(.horizontal)
                    }
                    List(viewModel.filteredChannels, id: \.self) { channel in
                        Button(action: {
                            selectedStreamUrl = IdentifiableURL(url: channel.url)
                        }) {
                            HStack {
                                ChannelImageView(url: channel.logoURL)
                                // Channel Title
                                Text(channel.name)
                                    .font(.headline)
                                    .foregroundColor(.primary)
                                Spacer()
                                Button(action: {
                                            
                                    if !purchaseManager.isPurchased {
                                        showPurchaseView = true
                                    }else {
                                        showPurchaseView = false
                                        toggleFavorite(channel)
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
                        }
                    }
                }
                
                
                
            }
            .navigationTitle("Channels")
            .navigationBarItems(trailing: HStack(spacing:16) {
                CastButton()
                    .frame(width:35, height: 35)
                MPVolumeViewWrapper()
                    .frame(width:35, height: 35)
            })
            
            .sheet(isPresented: $showPurchaseView) {
                           PurchaseView(purchaseManager: purchaseManager, isPresented: $showPurchaseView)
                       }

            .sheet(item: $selectedStreamUrl) {streamUrl in
                PlayerView(streamURL: streamUrl.url, purchaseManager: purchaseManager)
                
            }
        }
    }
    
    func toggleFavorite(_ channel: ChannelInfo) {
           if favoritesManager.isFavorite(channel) {
               favoritesManager.removeFromFavorites(channel)
           } else {
               favoritesManager.addToFavorites(channel)
           }
       }

    
    private func applyFilters(_ query:String) {
        if query.isEmpty {
            viewModel.filteredChannels = viewModel.channels
        } else {
            
            DispatchQueue.global(qos: .userInitiated).async {
                let results = viewModel.filteredChannels.filter { $0.name.lowercased().contains(query.lowercased()) }
                DispatchQueue.main.async {
                    viewModel.filteredChannels = results
                }
            }
        }
        
    }
    

}


//#Preview {
//    DashboardView()
//}
