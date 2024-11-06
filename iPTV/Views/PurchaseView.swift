//
//  PurchaseView.swift
//  iPTV
//
//  Created by Gaurav Kumar on 11/4/24.
//
import SwiftUI

struct PurchaseView: View {
    @ObservedObject var purchaseManager: PurchaseManager
    @Binding var isPresented: Bool  // Binding to dismiss the view
    @State private var isLoaded = false
    @State private var iconScale: CGFloat = 0.8
    @State private var buttonTapped = false

    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]),
                           startPoint: .topLeading,
                           endPoint: .bottomTrailing)
                .ignoresSafeArea()

            VStack(spacing: 30) {
                HStack {
                    Spacer()
                    Button(action: {
                        isPresented = false  // Dismiss view
                    }) {
                        Text("Cancel")
                            .foregroundColor(.white)
                            .padding(.horizontal)
                            .padding(.vertical, 8)
                            .background(Color.red.opacity(0.7))
                            .cornerRadius(8)
                    }
                    .padding()
                }
                
                Spacer()

                Image(systemName: "star.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.yellow)
                    .padding(.top, 40)
                    .scaleEffect(iconScale)
                    .onAppear {
                        withAnimation(.easeOut(duration: 1.0).repeatForever(autoreverses: true)) {
                            iconScale = 1.1
                        }
                    }

                Text("Unlock Premium Access")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .bold()
                    .multilineTextAlignment(.center)
                    .padding()
                    .opacity(isLoaded ? 1 : 0)
                    .animation(.easeIn(duration: 1.0), value: isLoaded)

                if purchaseManager.purchaseInProgress {
                    ProgressView("Processing...")
                        .foregroundColor(.white)
                } else {
                    Button(action: {
                        buttonTapped = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            buttonTapped = false
                            purchaseManager.purchase()
                        }
                    }) {
                        Text("Buy Now for $9.99")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(buttonTapped ? Color.green.opacity(0.6) : Color.green)
                            .cornerRadius(10)
                            .padding(.horizontal, 40)
                    }
                    .scaleEffect(buttonTapped ? 0.95 : 1.0)
                    .animation(.spring(), value: buttonTapped)

                    Button(action: {
                        buttonTapped = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            buttonTapped = false
                            purchaseManager.restorePurchases()
                        }
                    }) {
                        Text("Restore Purchase")
                            .font(.subheadline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(buttonTapped ? Color.gray.opacity(0.6) : Color.gray)
                            .cornerRadius(10)
                            .padding(.horizontal, 40)
                    }
                    .scaleEffect(buttonTapped ? 0.95 : 1.0)
                    .animation(.spring(), value: buttonTapped)
                }
                
                Spacer()
            }
        }
        .onAppear {
            isLoaded = true
           // purchaseManager.trackTrialPeriod()
        }
    }
}



