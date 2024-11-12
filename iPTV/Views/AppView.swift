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
    @StateObject private var networkMonitor = NetworkMonitor()
    @StateObject var historyManager = HistoryManager()
    @State private var showOfflineView = false
    
    var body: some View {
        ZStack{
            TabView {
//                DashboardView(purchaseManager:purchaseManager).tabItem{
//                    Label("Channels", systemImage: "list.dash")
//                }
                SearchIPTVLinkView(purchaseManager: purchaseManager).tabItem{
                    Label("Stream", systemImage: "magnifyingglass.circle.fill")
                }
                
                HistoryView().tabItem{
                    Label("History", systemImage: "clock.fill")
                }
                
                FavoritesView(purchaseManager: purchaseManager).tabItem{
                    Label("Favorites", systemImage: "star.fill")
                }
                
               
                MoreView(purchaseManager: purchaseManager)
                                   .tabItem {
                                       Label("More", systemImage: "ellipsis")
                                   }
            }
            
            .environmentObject(favoritesManager)
            .environmentObject(networkMonitor)
            .environmentObject(historyManager)
            // Show the OfflineView overlay when offline and the view is visible
            if !networkMonitor.isConnected && showOfflineView {
                Color.black.opacity(0.6)
                    .edgesIgnoringSafeArea(.all)

                OfflineView(retryAction: checkConnection, isVisible: $showOfflineView)
                    .frame(width: 300, height: 300)
                    .transition(.opacity)
            }
        }
        .onAppear {
                   // Show the OfflineView initially if not connected
                   showOfflineView = !networkMonitor.isConnected
               }
        
        .onChange(of: networkMonitor.isConnected) { isConnected in
                   // Hide OfflineView when the network reconnects
                   if isConnected {
                       showOfflineView = false
                   }
               }
       
    }
    
    // Check connection and update OfflineView
        private func checkConnection() {
            if networkMonitor.isConnected {
                showOfflineView = false
            } else {
                // Optionally trigger an alert or feedback if still offline
                print("Still offline. Please check your connection.")
            }
        }
}

#Preview {
    AppView()
}
