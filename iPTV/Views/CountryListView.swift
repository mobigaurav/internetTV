//
//  CountryListView.swift
//  iPTV
//
//  Created by Gaurav Kumar on 10/31/24.
//

import SwiftUI

struct CountryListView: View {
    @State private var countries: [String] = []
    @State private var isLoading = true
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
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(countries, id: \.self) { country in
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
                        self.isLoading = false
                    }
                }
            }.resume()
        }
}


#Preview {
    CountryListView()
}
