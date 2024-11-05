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
    @State private var channels: [ChannelInfo] = []
    @State private var filteredChannels: [ChannelInfo] = []
    @State private var searchText = ""
    @State private var selectedStreamUrl:IdentifiableURL?
    @State private var isLoading = true
    @State private var cancellable: AnyCancellable?
    private let cacheKey = "DashboardData"
    @ObservedObject var viewModel = DashboardViewModel()
    
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
                    TextField("Search channels...", text: $searchText)
                        .padding(10)
                        .background(Color(.systemGray5))
                        .cornerRadius(8)
                        .padding([.horizontal, .top])
                        .onSubmit{
                            self.applyFilters(searchText)
                        }
                    // Horizontal Scrollable Buttons
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 15) {
                            // Navigate to Category List
                            NavigationLink(destination: CategoryListView()) {
                                Text("Category")
                                    .padding(.vertical, 8)
                                    .padding(.horizontal, 12)
                                    .background(Color.blue)
                                    .foregroundColor(.white)
                                    .cornerRadius(15)
                            }
                            // Placeholder buttons for other groups
                            NavigationLink(destination: LanguageListView()) {
                                Text("Language")
                                    .padding(.vertical, 8)
                                    .padding(.horizontal, 12)
                                    .background(Color.blue)
                                    .foregroundColor(.white)
                                    .cornerRadius(15)
                            }
                            
                            NavigationLink(destination: CountryListView()) {
                                Text("Countries")
                                    .padding(.vertical, 8)
                                    .padding(.horizontal, 12)
                                    .background(Color.blue)
                                    .foregroundColor(.white)
                                    .cornerRadius(15)
                            }
                            NavigationLink(destination: RegionListView()) {
                                Text("Regions")
                                    .padding(.vertical, 8)
                                    .padding(.horizontal, 12)
                                    .background(Color.blue)
                                    .foregroundColor(.white)
                                    .cornerRadius(15)
                            }
                        }
                        .padding(.horizontal)
                    }
                    List(viewModel.channels) { channel in
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

            .sheet(item: $selectedStreamUrl) {streamUrl in
               PlayerView(streamURL: streamUrl.url)
                
            }
        }
    }

    
    private func applyFilters(_ query:String) {
        if query.isEmpty {
            filteredChannels = viewModel.channels
        } else {
            
            DispatchQueue.global(qos: .userInitiated).async {
                let results = self.viewModel.channels.filter { $0.name.lowercased().contains(query.lowercased()) }
                DispatchQueue.main.async {
                    self.filteredChannels = results
                }
            }
        }
        
    }
    

}


#Preview {
    DashboardView()
}
