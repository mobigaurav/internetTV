//
//  MoreView.swift
//  iPTV
//
//  Created by Gaurav Kumar on 11/4/24.
//
import SwiftUI

struct MoreView: View {
    @ObservedObject var purchaseManager: PurchaseManager
    @State private var showPurchaseView = false

    var body: some View {
        NavigationView {
            ZStack {
                Color(.systemGray6).ignoresSafeArea()  // Background color

                List {
                    Section(header: Text("Options").font(.headline).foregroundColor(.black)) {
                        if !purchaseManager.isPurchased {
                            Button(action: {
                                showPurchaseView = true
                            }) {
                                HStack {
                                    Image(systemName: "cart.fill")
                                        .foregroundColor(.green)
                                    Text("Buy Paid Version - $5.99")
                                        .foregroundColor(.primary)
                                        .font(.body)
                                }
                                .padding(10)
                                .background(Color.white)
                                .cornerRadius(10)
                            }
                        }

                        Button(action: shareApp) {
                            HStack {
                                Image(systemName: "square.and.arrow.up")
                                    .foregroundColor(.blue)
                                Text("Share App with Friends")
                                    .foregroundColor(.primary)
                                    .font(.body)
                            }
                            .padding(10)
                            .background(Color.white)
                            .cornerRadius(10)
                        }

                        NavigationLink(destination: AboutAppView()) {
                            HStack {
                                Image(systemName: "info.circle")
                                    .foregroundColor(.purple)
                                Text("About App")
                                    .foregroundColor(.primary)
                                    .font(.body)
                            }
                            .padding(10)
                            .background(Color.white)
                            .cornerRadius(10)
                        }
                    }
                    .padding(.vertical, 8)
                }
                .navigationTitle("More")
                .sheet(isPresented: $showPurchaseView) {
                               PurchaseView(purchaseManager: purchaseManager, isPresented: $showPurchaseView)
                           }
            }
        }
    }

    private func shareApp() {
        let appLink = URL(string: "https://example.com")!  // Replace with actual app link
        let activityVC = UIActivityViewController(activityItems: [appLink], applicationActivities: nil)
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            windowScene.windows.first?.rootViewController?.present(activityVC, animated: true, completion: nil)
        }
    }
}



