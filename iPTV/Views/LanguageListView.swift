//
//  LanguageListView.swift
//  iPTV
//
//  Created by Gaurav Kumar on 10/31/24.
//

import SwiftUI

struct LanguageListView: View {
    @State private var languages: [String] = []  // List of unique languages
    @State private var filteredlanguages: [String] = []  // List of unique languages
    @State private var isLoading = true
    @State private var searchText = ""
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    var body: some View {
        VStack {
            if isLoading {
                ProgressView("Loading Languages...")
                    .padding()
            } else {
                // Search Bar
                TextField("Search Languages...", text: $searchText)
                    .padding(10)
                    .background(Color(.systemGray5))
                    .cornerRadius(8)
                    .padding([.horizontal, .top])
                    .onSubmit{
                        self.applyFilters(searchText)
                    }
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(filteredlanguages, id: \.self) { language in
                            NavigationLink(
                                destination: {
                                    ChannelListView(filterType: .language(language))
                                }
                            ) {
                                CategoryCardView(category: language)
                            }
                            .buttonStyle(PlainButtonStyle())
                          
                        }
                    }
                    .padding()
                }
            }
        }
        .navigationTitle("Languages")
        .onAppear(perform: loadLanguages)
    }
    
    private func applyFilters(_ query:String) {
        if query.isEmpty {
            filteredlanguages = self.languages
        } else {
            DispatchQueue.global(qos: .userInitiated).async {
                let results = self.filteredlanguages.filter { $0.lowercased().contains(query.lowercased()) }
                DispatchQueue.main.async {
                    self.filteredlanguages = results
                }
            }
        }
    }
    
    private func loadLanguages() {
            // Load the .m3u file specific for languages
            let urlString = "https://iptv-org.github.io/iptv/index.language.m3u"
            guard let url = URL(string: urlString) else { return }
            
            URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data, error == nil else { return }
                if let dataString = String(data: data, encoding: .utf8) {
                    let parsedChannels = M3UParser.parse(dataString)
                    
                    // Extract unique languages using the group-title attribute
                    let uniqueLanguages = Set(parsedChannels.compactMap { $0.groupTitle }).sorted()
                    
                    DispatchQueue.main.async {
                        self.languages = uniqueLanguages
                        self.filteredlanguages = self.languages
                        self.isLoading = false
                    }
                }
            }.resume()
        }
}


#Preview {
    LanguageListView()
}
