//
//  CountryListView.swift
//  iPTV
//
//  Created by Gaurav Kumar on 10/31/24.
//

import SwiftUI

struct CountryListView: View {
    @State private var countries: [String] = []
    @State private var filteredCountries: [String] = []  // List of unique languages
    @State private var isLoading = true
    @State private var searchText = ""
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    var body: some View {
        VStack {
            if isLoading {
                ProgressView("Loading Countries...")
                    .padding()
            } else {
                // Search Bar
                TextField("Search Countries...", text: $searchText)
                    .padding(10)
                    .background(Color(.systemGray5))
                    .cornerRadius(8)
                    .padding([.horizontal, .top])
                    .onSubmit{
                        self.applyFilters(searchText)
                    }
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(filteredCountries, id: \.self) { country in
                            NavigationLink(
                                destination: {
                                    ChannelListView(filterType: .country(country))
                                }
                            ) {
                                CategoryCardView(category: country)
                            }
                            .buttonStyle(PlainButtonStyle())
                          
                        }
                    }
                    .padding()
                }
            }
        }
        .navigationTitle("Countries")
        .onAppear(perform: loadCountries)
    }
    
    private func applyFilters(_ query:String) {
        if query.isEmpty {
            filteredCountries = self.countries
        } else {
            DispatchQueue.global(qos: .userInitiated).async {
                let results = self.filteredCountries.filter { $0.lowercased().contains(query.lowercased()) }
                DispatchQueue.main.async {
                    self.filteredCountries = results
                }
            }
        }
    }
    
    private func loadCountries() {
            // Load the .m3u file specific for languages
            let urlString = "https://iptv-org.github.io/iptv/index.country.m3u"
            guard let url = URL(string: urlString) else { return }
            
            URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data, error == nil else { return }
                if let dataString = String(data: data, encoding: .utf8) {
                    let parsedChannels = M3UParser.parse(dataString)
                    
                    // Extract unique languages using the group-title attribute
                    let uniqueCountries = Set(parsedChannels.compactMap { $0.groupTitle }).sorted()
                    
                    DispatchQueue.main.async {
                        self.countries = uniqueCountries
                        self.filteredCountries = self.countries
                        self.isLoading = false
                    }
                }
            }.resume()
        }
}


#Preview {
    CountryListView()
}
