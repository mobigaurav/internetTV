//
//  DashboardViewNew.swift
//  iPTV
//
//  Created by Gaurav Kumar on 10/31/24.
//

import SwiftUI
import Combine

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
//            .onAppear{
//                // Load from cache if available
//                if let cachedChannels = CacheManager.shared.loadChannels(forKey: cacheKey) {
//                    //self.channels = cachedChannels
//                    self.filteredChannels = cachedChannels
//                    self.isLoading = false
//                } else {
//                    loadChannels()
//                }
//            }
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
    
  
    private func loadChannels() {
        guard let url = URL(string: "https://iptv-org.github.io/iptv/index.m3u") else { return }

        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else { return }

            if let dataString = String(data: data, encoding: .utf8) {
                DispatchQueue.global(qos: .userInitiated).async {
                    // Parse channels
                    let parsedChannels = M3UParser.parse(dataString)
                    
                    DispatchQueue.main.async {
                        // Update UI and save to cache
                        self.channels = parsedChannels
                        self.filteredChannels = parsedChannels
                        self.isLoading = false
                        CacheManager.shared.saveChannels(parsedChannels, forKey: self.cacheKey)
                    }
                }
            }
        }.resume()
    }
}


#Preview {
    DashboardView()
}
