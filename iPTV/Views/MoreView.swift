//
//  MoreView.swift
//  iPTV
//
//  Created by Gaurav Kumar on 11/4/24.
//
import SwiftUI
import MessageUI

struct MoreView: View {
    @ObservedObject var purchaseManager: PurchaseManager
    @State private var showPurchaseView = false
    @State private var showShareSheet = false  // Control for presenting the share sheet
    @State private var showMailView = false
    @State private var showMailErrorAlert = false
    
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
                        
                        Button(action: {
                            if purchaseManager.isPurchased {
                                showPurchaseView = true
                                showMailView = false
                            }else {
                                showPurchaseView = false
                                showMailView = true
                            }
                            
                        }) {
                            HStack {
                                Image(systemName: "envelope")
                                    .foregroundColor(.orange)
                                Text("Contact Us")
                                    .foregroundColor(.primary)
                                    .font(.body)
                            }
                            .padding(10)
                            .background(Color.white)
                            .cornerRadius(10)
                        }
                        .actionSheet(isPresented: $showMailView) {
                            ActionSheet(
                                title: Text("Choose Email App"),
                                message: Text("Select an email app to contact us"),
                                buttons: [
                                    .default(Text("Apple Mail")) {
                                        if MFMailComposeViewController.canSendMail() {
                                            showMailView = true
                                        } else {
                                            showMailErrorAlert = true
                                        }
                                    },
                                    .default(Text("Gmail")) {
                                        openGmail()
                                    },
                                    .cancel()
                                ]
                            )
                        }
                        
                        .alert(isPresented: $showMailErrorAlert) {
                            Alert(
                                title: Text("Mail Services Unavailable"),
                                message: Text("Please set up a mail account in the Mail app to send email."),
                                dismissButton: .default(Text("OK"))
                            )
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
                .sheet(isPresented: $showMailView) {
                    if MFMailComposeViewController.canSendMail() {
                        MailView(
                            recipients: ["mobigaurav@gmail.com"],  // Replace with your email
                            subject: "App Feedback",
                            messageBody: "Hello, I would like to provide feedback about the app."
                        )
                    } else {
                        Text("Mail services are not available.")
                    }
                }
            }
        }
    }
    
    private func openGmail() {
        let gmailURL = URL(string: "googlegmail://co?to=mobigaurav@gmail.com&subject=App%20Feedback")!
        if UIApplication.shared.canOpenURL(gmailURL) {
            UIApplication.shared.open(gmailURL)
        } else {
            openMailToLink()  // Fallback to web-based mailto link
        }
    }
    
    private func openMailToLink() {
        let mailtoURL = URL(string: "mailto:mobigaurav@gmail.com?subject=App%20Feedback")!
        UIApplication.shared.open(mailtoURL)
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



