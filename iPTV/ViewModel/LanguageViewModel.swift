//
//  LanguageViewModel.swift
//  iPTV
//
//  Created by Gaurav Kumar on 11/5/24.
//

import Foundation
import Combine

class LanguageViewModel: ObservableObject {
    @Published var languages: [String] = []
    @Published var filteredLang: [String] = []
    @Published var isLoading: Bool = true
    private let cacheKey = "LangaugeView"

    init() {
        loadLang()
    }

    private func loadLang() {
        // Check for cached data
        if let cachedChannels = CacheManager.shared.loadLanguage(forKey: cacheKey) {
            self.languages = cachedChannels
            self.filteredLang = self.languages
            self.isLoading = false
        } else {
            loadLanguages()
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
                        self.filteredLang = self.languages
                        self.isLoading = false
                        CacheManager.shared.saveRegion(self.languages, forKey: self.cacheKey)
                    }
                }
            }.resume()
        }
}
