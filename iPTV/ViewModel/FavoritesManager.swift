//
//  FavoritesManager.swift
//  iPTV
//
//  Created by Gaurav Kumar on 10/31/24.
//

import Foundation

class FavoritesManager: ObservableObject {
    @Published private(set) var favoriteChannels: [ChannelInfo] = []

    private let favoritesKey = "favoriteChannels"

    init() {
        loadFavorites()
    }

    func addToFavorites(_ channel: ChannelInfo) {
        if !favoriteChannels.contains(where: { $0.id == channel.id }) {
            favoriteChannels.append(channel)
            saveFavorites()
        }
    }

    func removeFromFavorites(_ channel: ChannelInfo) {
        favoriteChannels.removeAll { $0.id == channel.id }
        saveFavorites()
    }

    func isFavorite(_ channel: ChannelInfo) -> Bool {
        favoriteChannels.contains { $0.id == channel.id }
    }

    private func saveFavorites() {
        if let encoded = try? JSONEncoder().encode(favoriteChannels) {
            UserDefaults.standard.set(encoded, forKey: favoritesKey)
        }
    }

    private func loadFavorites() {
        if let data = UserDefaults.standard.data(forKey: favoritesKey),
           let decoded = try? JSONDecoder().decode([ChannelInfo].self, from: data) {
            favoriteChannels = decoded
        }
    }
}

