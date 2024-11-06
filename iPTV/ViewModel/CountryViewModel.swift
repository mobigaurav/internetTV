//
//  CountryViewModel.swift
//  iPTV
//
//  Created by Gaurav Kumar on 11/5/24.
//

import Foundation
import Combine

class CountryViewModel: ObservableObject {
    @Published var countries: [String] = []
    @Published var filteredCountries: [String] = []
    @Published var isLoading: Bool = true
    private let cacheKey = "LanguageView"

    init() {
        loadCountry()
    }

    private func loadCountry() {
        // Check for cached data
        if let cachedChannels = CacheManager.shared.loadCountry(forKey: cacheKey) {
            self.countries = cachedChannels
            self.filteredCountries = self.countries
            self.isLoading = false
        } else {
            loadCountries()
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
                        CacheManager.shared.saveRegion(self.countries, forKey: self.cacheKey)
                    }
                }
            }.resume()
        }
}
