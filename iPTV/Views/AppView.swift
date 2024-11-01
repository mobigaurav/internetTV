//
//  AppView.swift
//  iPTV
//
//  Created by Gaurav Kumar on 10/30/24.
//

import SwiftUI

struct AppView: View {
    @StateObject private var favoritesManager = FavoritesManager()
    var body: some View {
        TabView {
            DashboardView().tabItem{
                Label("Channels", systemImage: "list.dash")
            }
            
            FavoritesView().tabItem{
                Label("Favorites", systemImage: "star.fill")
            }
        }
        .environmentObject(favoritesManager)
    }
}

#Preview {
    AppView()
}
