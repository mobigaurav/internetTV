//
//  DashboardViewModel.swift
//  iPTV
//
//  Created by Gaurav Kumar on 10/31/24.
//

import Foundation
import Combine

class DashboardViewModel: ObservableObject {
    @Published var channels: [ChannelInfo] = []
    @Published var filteredChannels: [ChannelInfo] = []
    @Published var isLoading: Bool = true
    private let cacheKey = "DashboardChannels"

    init() {
        loadChannels()
    }

    private func loadChannels() {
        // Check for cached data
        if let cachedChannels = CacheManager.shared.loadChannels(forKey: cacheKey) {
            self.channels = cachedChannels
            self.filteredChannels = self.channels
            self.isLoading = false
        } else {
            fetchDashboardData()
        }
    }

    private func fetchDashboardData() {
        guard let url = URL(string: "https://iptv-org.github.io/iptv/index.m3u") else { return }

        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else { return }

            if let dataString = String(data: data, encoding: .utf8) {
                DispatchQueue.global(qos: .userInitiated).async {
                    // Parse channels
                    let parsedChannels = M3UParser.parse(dataString)
                    
                    DispatchQueue.main.async {
                        // Update channels and save to cache
                        self.channels = parsedChannels
                        self.filteredChannels = self.channels
                        self.isLoading = false
                        CacheManager.shared.saveChannels(self.channels, forKey: self.cacheKey)
                    }
                }
            }
        }.resume()
    }
}

