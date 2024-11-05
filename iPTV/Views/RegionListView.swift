//
//  RegionListView.swift
//  iPTV
//
//  Created by Gaurav Kumar on 10/31/24.
//

import SwiftUI

struct RegionListView: View {
    @State private var regions: [String] = []
    @State private var filteredregions: [String] = []
    @State private var isLoading = true
    @State private var searchText = ""
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    var body: some View {
        VStack {
            if isLoading {
                ProgressView("Loading Regions...")
                    .padding()
            } else {
                // Search Bar
                TextField("Search Regions...", text: $searchText)
                    .padding(10)
                    .background(Color(.systemGray5))
                    .cornerRadius(8)
                    .padding([.horizontal, .top])
                    .onSubmit{
                        self.applyFilters(searchText)
                    }
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(filteredregions, id: \.self) { region in
                            NavigationLink(
                                destination: {
                                    ChannelListView(filterType: .region(region))
                                }
                            ) {
                                CategoryCardView(category: region)
                            }
                            .buttonStyle(PlainButtonStyle())
                          
                        }
                    }
                    .padding()
                }
            }
        }
        .navigationTitle("Regions")
        .onAppear(perform: loadRegions)
    }
    
    private func applyFilters(_ query:String) {
        if query.isEmpty {
            filteredregions = self.regions
        } else {
            DispatchQueue.global(qos: .userInitiated).async {
                let results = self.filteredregions.filter { $0.lowercased().contains(query.lowercased()) }
                DispatchQueue.main.async {
                    self.filteredregions = results
                }
            }
        }
    }
    
    private func loadRegions() {
            // Load the .m3u file specific for languages
            let urlString = "https://iptv-org.github.io/iptv/index.region.m3u"
            guard let url = URL(string: urlString) else { return }
            
            URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data, error == nil else { return }
                if let dataString = String(data: data, encoding: .utf8) {
                    let parsedChannels = M3UParser.parse(dataString)
                    
                    // Extract unique languages using the group-title attribute
                    let uniqueRegions = Set(parsedChannels.compactMap { $0.groupTitle }).sorted()
                    
                    DispatchQueue.main.async {
                        self.regions = uniqueRegions
                        self.filteredregions = self.regions
                        self.isLoading = false
                    }
                }
            }.resume()
        }
}


#Preview {
    RegionListView()
}
