//
//  DashboardView.swift
//  iPTV
//
//  Created by Gaurav Kumar on 10/25/24.
//

import SwiftUI

struct DashboardViewOld: View {
    @StateObject var viewModel = ChannelViewModel()
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        NavigationView {
            VStack {
                if viewModel.isLoading {
                    LoadingView()
                } else {
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 20) {
                            ForEach(viewModel.categories) { category in
                                NavigationLink(
                                    destination: {
                                        ChannelListViewOld(viewModel: viewModel)
                                    }
                                ) {
                                    //CategoryCardView(category: category)
                                }
                                .buttonStyle(PlainButtonStyle())
                              
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("Categories")
            .onAppear {
                viewModel.loadCachedDataOrFetch()
            }
        }
    }
}


//#Preview {
//    DashboardView()
//}
