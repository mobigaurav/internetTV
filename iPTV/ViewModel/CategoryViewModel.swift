//
//  CategoryViewModel.swift
//  iPTV
//
//  Created by Gaurav Kumar on 11/5/24.
//

import Foundation
import Combine

class CategoryViewModel: ObservableObject {
    @Published var categories: [String] = []
    @Published var filteredCategories: [String] = []
    @Published var isLoading: Bool = true
    private let cacheKey = "CategoryView"

    init() {
        loadCategory()
    }

     func loadCategory() {
        // Check for cached data
        if let cachedChannels = CacheManager.shared.loadCategory(forKey: cacheKey) {
            self.categories = cachedChannels
            self.filteredCategories = self.categories
            self.isLoading = false
        } else {
            loadCategories()
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
                    let uniqueCategories = Set(parsedChannels.compactMap { $0.groupTitle }).sorted()
                    
                    DispatchQueue.main.async {
                        self.categories = uniqueCategories
                        self.filteredCategories = self.categories
                        self.isLoading = false
                        CacheManager.shared.saveCategory(self.categories, forKey: self.cacheKey)
                    }
                }
            }.resume()
        }
}
