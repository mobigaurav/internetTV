//
//  LoadingView.swift
//  iPTV
//
//  Created by Gaurav Kumar on 10/29/24.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        ZStack{
            LinearGradient(
                gradient: Gradient(colors: [Color.blue.opacity(0.3), Color.purple.opacity(0.3)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing:20) {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .scaleEffect(2)
                    .shadow(radius:10)
                
                Text("Loading ...")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .shadow(radius: 10)
            }
            .padding(50)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.black.opacity(0.6))
            )
            .shadow(radius: 10)
        }
    }
}

