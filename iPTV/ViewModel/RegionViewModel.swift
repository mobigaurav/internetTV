//
//  RegionViewModel.swift
//  iPTV
//
//  Created by Gaurav Kumar on 11/5/24.
//

import Foundation
import Combine

class RegionViewModel: ObservableObject {
    @Published var regions: [String] = []
    @Published var filteredRegions: [String] = []
    @Published var isLoading: Bool = true
    private let cacheKey = "RegionView"

    init() {
        loadRegion()
    }

    private func loadRegion() {
        // Check for cached data
        if let cachedChannels = CacheManager.shared.loadRegion(forKey: cacheKey) {
            self.regions = cachedChannels
            self.filteredRegions = self.regions
            self.isLoading = false
        } else {
            loadRegions()
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
                        self.filteredRegions = self.regions
                        self.isLoading = false
                        CacheManager.shared.saveRegion(self.regions, forKey: self.cacheKey)
                    }
                }
            }.resume()
        }
}
