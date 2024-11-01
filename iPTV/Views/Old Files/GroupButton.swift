//
//  GroupButton.swift
//  iPTV
//
//  Created by Gaurav Kumar on 10/31/24.
//

import SwiftUI

struct GroupButton: View {
    let title:String
    let action:() -> Void
    
    var body: some View {
        Button(action:action) {
            Text(title)
                .padding(.vertical, 8)
                .padding(.horizontal, 12)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(15)
        }
    }
}
