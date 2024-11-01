//
//  CategoryCardView.swift
//  iPTV
//
//  Created by Gaurav Kumar on 10/29/24.
//

import SwiftUI

struct CategoryCardView:View {
    let category:String
    
    var body:some View {
        ZStack {
            //Gradient Background
            LinearGradient(
                gradient: Gradient(colors: [Color.blue.opacity(0.8), Color.purple.opacity(0.8)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .cornerRadius(15)
            .shadow(radius: 5)
            
            //Category title
            Text(category)
                .font(.headline)
                .foregroundColor(.white)
                .bold()
                .multilineTextAlignment(.center)
        }
        .frame(height:150)
    }
}

#Preview {
    CategoryCardView(category: "")
}
