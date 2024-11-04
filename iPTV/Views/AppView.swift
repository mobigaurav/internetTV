//
//  AppView.swift
//  iPTV
//
//  Created by Gaurav Kumar on 10/30/24.
//

import SwiftUI

struct AppView: View {
    @StateObject private var favoritesManager = FavoritesManager()
    @StateObject private var purchaseManager = PurchaseManager()
    
    var body: some View {
        TabView {
            DashboardView().tabItem{
                Label("Channels", systemImage: "list.dash")
            }
            
            FavoritesView().tabItem{
                Label("Favorites", systemImage: "star.fill")
            }
            
            SearchIPTVLinkView().tabItem{
                Label("Stream", systemImage: "magnifyingglass.circle.fill")
            }
            MoreView(purchaseManager: purchaseManager)
                               .tabItem {
                                   Label("More", systemImage: "ellipsis")
                               }
        }
        .environmentObject(favoritesManager)
    }
}

#Preview {
    AppView()
}
