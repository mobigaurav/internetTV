//
//  CategoryListView.swift
//  iPTV
//
//  Created by Gaurav Kumar on 10/31/24.
//

import SwiftUI


struct CategoryListView: View {
    @State private var categories: [String] = []  // List of unique categories
    @State private var filteredCategores:[String] = []
    @State private var selectedCategory: String?
    @State private var isLoading = true
    @State private var searchText = ""
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    var body: some View {
            VStack {
                if isLoading {
                    ProgressView("Loading Categories...")
                        .padding()
                } else {
                    // Search Bar
                    TextField("Search categories...", text: $searchText)
                        .padding(10)
                        .background(Color(.systemGray5))
                        .cornerRadius(8)
                        .padding([.horizontal, .top])
                        .onSubmit{
                            self.applyFilters(searchText)
                        }
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 20) {
                            ForEach(filteredCategores, id: \.self) { category in
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
    
    private func applyFilters(_ query:String) {
        if query.isEmpty {
            filteredCategores = self.categories
        } else {
            DispatchQueue.global(qos: .userInitiated).async {
                let results = self.filteredCategores.filter { $0.lowercased().contains(query.lowercased()) }
                DispatchQueue.main.async {
                    self.filteredCategores = results
                }
            }
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
                        self.filteredCategores = self.categories
                        self.isLoading = false
                    }
                }
            }.resume()
        }
}



#Preview {
    CategoryListView()
}
