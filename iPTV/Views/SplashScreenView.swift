//
//  SplashScreenView.swift
//  iPTV
//
//  Created by Gaurav Kumar on 11/4/24.
//

import SwiftUI

struct SplashScreenView: View {
    @State private var isActive = false  // Controls navigation to the main view
    @State private var logoScale: CGFloat = 0.8  // Controls logo scaling for animation
    @ObservedObject var viewModel = DashboardViewModel()

    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]),
                           startPoint: .topLeading,
                           endPoint: .bottomTrailing)
                .ignoresSafeArea()

            VStack {
                Spacer()

                // App logo with scaling animation
                Image(systemName: "tv.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)
                    .foregroundColor(.yellow)
                    .scaleEffect(logoScale)
                    .onAppear {
                        withAnimation(.easeOut(duration: 0.5).repeatForever(autoreverses: true)) {
                            logoScale = 1.1  // Pulsing effect
                        }
                    }

                // App name
                Text("iStreamX")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .bold()
                    .padding(.top, 20)
                
                Text("iPTV streaming player")
                    .font(.subheadline)
                    .foregroundColor(.white)
                    .bold()
                    .padding(.top, 20)

                Spacer()

                // Loading indicator
                ProgressView("Loading...")
                    .foregroundColor(.white)
                    .padding(.bottom, 40)
            }
        }
        .onAppear {
            // Delay before transitioning to the main content
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                isActive = true
            }
        }
        // Navigate to the main content when the splash is complete
        .fullScreenCover(isPresented: $isActive) {
            AppView()  // Replace with your main content view
        }
    }
}

