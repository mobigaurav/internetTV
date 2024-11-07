//
//  OfflineView.swift
//  iPTV
//
//  Created by Gaurav Kumar on 11/6/24.
//

import SwiftUI

struct OfflineView: View {
    var retryAction: () -> Void
    @Binding var isVisible: Bool
    
    var body: some View {
        VStack {
            Image(systemName: "wifi.exclamationmark")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .foregroundColor(.gray)
                .padding()

            Text("No Internet Connection")
                .font(.title)
                .bold()
                .padding(.top, 10)
            
            Text("Please check your network settings and try again.")
                .font(.body)
                .foregroundColor(.secondary)
                .padding(.horizontal, 20)
                .multilineTextAlignment(.center)
                .padding(.top, 5)
            
            HStack(spacing: 20) {
                // Retry button
                Button(action: retryAction) {
                    Text("Retry")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }

                // Cancel button
                Button(action: { isVisible = false }) {
                    Text("Cancel")
                        .padding()
                        .background(Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 10)
    }
}

