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
    @State private var showShareSheet = false  // Control for presenting the share sheet
    
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
                                    Text("Buy Paid Version - $9.99")
                                        .foregroundColor(.primary)
                                        .font(.body)
                                }
                                .padding(10)
                                .background(Color.white)
                                .cornerRadius(10)
                            }
                        }

                        Button(action: {
                            showShareSheet = true
                        }) {
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
                .sheet(isPresented: $showShareSheet) {
                                ActivityView(activityItems: [URL(string: "https://apps.apple.com/us/app/istreamx/id6737782720")!])  // Replace with your app link
                            }
            }
        }
    }

    private func shareApp() {
        let appLink = URL(string: "https://example.com")!  // Replace with actual app link
        let activityVC = UIActivityViewController(activityItems: [appLink], applicationActivities: nil)
        
        // Present the UIActivityViewController from the root view controller
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootVC = windowScene.windows.first?.rootViewController {
            rootVC.present(activityVC, animated: true, completion: nil)
        }
    }
}



