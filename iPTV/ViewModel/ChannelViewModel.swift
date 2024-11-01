import SwiftUI

class ChannelViewModel: ObservableObject {
    @Published var categories: [Category] = []
    @Published var channels: [Channel] = []
    @Published var language: [Language] = []
    @Published var region: [Region] = []
    @Published var country: [Country] = []
    @Published var subdivision: [Subdivision] = []
    @Published var favorites:[Channel] = []
    
    @Published var filteredChannels: [Channel] = []  // Only channels relevant to selected category
    @Published var searchText: String = "" 
    @Published var selectedLanguage: String?
    @Published var selectedCountry: String?
    @Published var selectedRegion: String?
    @Published var selectedSubdivision: String?
    @Published var errorMessage: String?
    @Published var isLoading = false
    @Published var isLoadingStreams = false
    private let favoritesKey = "favoriteChannels"
    private var searchDebounceTimer: Timer?
    private var allChannels: [Channel] = []
    private var allStreams: [Stream] = []

    init() {
        loadChannels()
        //loadCachedDataOrFetch()
        //loadFavorites()
    }
    
    func loadChannels(){
        NetworkManager.shared.fetchChannels {[weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let channels):
                    self?.channels = channels
                    self?.isLoading = false
                    
                case .failure(let error):
                self?.errorMessage = error.localizedDescription
                self?.isLoading = false
                }
            }
        }
    }
    
    
     func fetchChannels() {
        NetworkManager.shared.fetchChannels { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let channels):
                    self?.allChannels = channels
                    CacheManager.save(channels, to: "channels.json")
                    self?.fetchStreams()
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                    self?.isLoading = false
                }
            }
        }
    }
    
    // Toggle favorite status for a channel
        func toggleFavorite(for channel: Channel) {
            if let index = channels.firstIndex(where: { $0.id == channel.id }) {
                channels[index].isFavorite.toggle()
                updateFavoritesList()
                saveFavorites()  // Save updated favorites list
            }
        }
    
    // Update favorites list based on current channel states
       private func updateFavoritesList() {
           favorites = channels.filter { $0.isFavorite }  // Re-filter favorites
       }

       // Save favorites to local storage
       private func saveFavorites() {
           CacheManager.save(favorites, to: favoritesKey)
       }

       // Load favorites from local storage
       private func loadFavorites() {
           if let savedFavorites: [Channel] = CacheManager.load([Channel].self, from: favoritesKey) {
               for savedFavorite in savedFavorites {
                   if let index = channels.firstIndex(where: { $0.id == savedFavorite.id }) {
                       channels[index].isFavorite = true
                   }
               }
               updateFavoritesList()  // Ensure the favorites list is updated
           }
       }
    
    func loadCachedDataOrFetch() {
        isLoading = true
        if let cachedCategories: [Category] = CacheManager.load([Category].self, from: "categories.json"),
           let cachedChannels: [Channel] = CacheManager.load([Channel].self, from: "channels.json"),
           //let cachedCountries: [Country] = CacheManager.load([Country].self, from: "countries.json"),
           //let cachedLanguages: [Language] = CacheManager.load([Language].self, from: "languages.json"),
           let cachedStreams: [Stream] = CacheManager.load([Stream].self, from: "streams.json") {
            self.categories = cachedCategories
            self.allChannels = cachedChannels
            self.allStreams = cachedStreams
           // self.country = cachedCountries
            //self.language = cachedLanguages
            self.updateChannelsWithStreams()
            self.isLoading = false
        } else {
            fetchCategories()
            //fetchCountries()
        }
    }
    
    // Debounce the search operation
        private func debounceSearch() {
            searchDebounceTimer?.invalidate()
            searchDebounceTimer = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false) { [weak self] _ in
                self?.applyFilters()
            }
        }
    
    // Apply search and filter criteria in a background thread
        func applyFilters() {
            DispatchQueue.global(qos: .userInitiated).async {
                let filtered = self.channels.filter { channel in
                    let matchesSearchText = self.searchText.isEmpty || channel.name.lowercased().contains(self.searchText.lowercased())
                  //  let matchesLanguage = self.selectedLanguage == nil || channel.languages!.contains(self.selectedLanguage!)
                   // let matchesCountry = self.selectedCountry == nil || channel.country == self.selectedCountry
//                  //  let matchesRegion = self.selectedRegion == nil || channel.broadcastArea!.contains { $0.hasPrefix(self.selectedRegion!) }
//                    let matchesSubdivision = self.selectedSubdivision == nil || channel.subdivision == self.selectedSubdivision

                    return matchesSearchText 
                }
                
                // Update UI on the main thread
                DispatchQueue.main.async {
                    self.filteredChannels = filtered
                }
            }
        }
    
    func fetchCountries() {
        NetworkManager.shared.fetchCountries { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let countries):
                    self?.country = countries
                    CacheManager.save(countries, to: "countries.json")
                    self?.fetchLanguages()
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                    self?.isLoading = false
                }
            }
        }
    }
    
    func fetchLanguages() {
        NetworkManager.shared.fetchLanguages { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let languages):
                    self?.language = languages
                    CacheManager.save(languages, to: "languages.json")
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                    self?.isLoading = false
                }
            }
        }
    }

     func fetchCategories() {
        NetworkManager.shared.fetchCategories { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let categories):
                    self?.categories = categories
                    CacheManager.save(categories, to: "categories.json")
                    self?.fetchChannels()
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                    self?.isLoading = false
                }
            }
        }
    }

    
     func fetchStreams() {
        NetworkManager.shared.fetchStreams { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let streams):
                    self?.allStreams = streams
                    CacheManager.save(streams, to: "streams.json")
                    self?.updateChannelsWithStreams()
                    self?.isLoading = false
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                    self?.isLoading = false
                }
            }
        }
    }
    
    // Update channels with streams and filter by selected category
     func updateChannelsWithStreams() {
        let streamsDict = Dictionary(grouping: allStreams, by: { $0.channel })
        channels = allChannels.compactMap { channel in
            if let channelStreams = streamsDict[channel.id], !channelStreams.isEmpty {
                var updatedChannel = channel
                updatedChannel.streams = channelStreams
                return updatedChannel
            }
            return nil
        }
    }

    // Filter channels by selected category
    func filterChannels(by categoryID: String) {
        filteredChannels = channels.filter { $0.categories.contains(categoryID) }
    }
}
