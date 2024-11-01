//
//  CategoryListView.swift
//  iPTV
//
//  Created by Gaurav Kumar on 10/31/24.
//

import SwiftUI


struct CategoryListView: View {
    @State private var categories: [String] = []  // List of unique categories
    @State private var selectedCategory: String?
    @State private var isLoading = true
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    var body: some View {
        NavigationView {
            VStack {
                if isLoading {
                    ProgressView("Loading Categories...")
                        .padding()
                } else {                    
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 20) {
                            ForEach(categories, id: \.self) { category in
                                NavigationLink(
                                    destination: {
                                        ChannelListView(filterType: .category(category))
                                    }
                                ) {
                                    CategoryCardView(category: category)
                                }
                                .buttonStyle(PlainButtonStyle())
                              
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("Categories")
            .onAppear(perform: loadCategories)
        }
    }
    
    private func loadCategories() {
            // Load the .m3u file specific for languages
            let urlString = "https://iptv-org.github.io/iptv/index.category.m3u"
            guard let url = URL(string: urlString) else { return }
            
            URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data, error == nil else { return }
                if let dataString = String(data: data, encoding: .utf8) {
                    let parsedChannels = M3UParser.parse(dataString)
                    
                    // Extract unique languages using the group-title attribute
                    let uniqueLanguages = Set(parsedChannels.compactMap { $0.groupTitle }).sorted()
                    
                    DispatchQueue.main.async {
                        self.categories = uniqueLanguages
                        self.isLoading = false
                    }
                }
            }.resume()
        }
}



#Preview {
    CategoryListView()
}
