//
//  RegionListView.swift
//  iPTV
//
//  Created by Gaurav Kumar on 10/31/24.
//

import SwiftUI

struct RegionListView: View {
    @State private var searchText = ""
    @ObservedObject var viewModel = RegionViewModel()
    @ObservedObject var purchaseManager: PurchaseManager
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    var body: some View {
        VStack {
            if viewModel.isLoading {
                ProgressView("Loading Regions...")
                    .padding()
            } else {
                // Search Bar
                TextField("Search Regions...", text: $searchText)
                    .padding(10)
                    .background(Color(.systemGray5))
                    .cornerRadius(8)
                    .padding([.horizontal, .top])
                    .onSubmit{
                        self.applyFilters(searchText)
                    }
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(viewModel.filteredRegions, id: \.self) { region in
                            NavigationLink(
                                destination: {
                                    ChannelListView(filterType: .region(region), purchaseManager: purchaseManager)
                                }
                            ) {
                                CategoryCardView(category: region)
                            }
                            .buttonStyle(PlainButtonStyle())
                          
                        }
                    }
                    .padding()
                }
            }
        }
        .navigationTitle("Regions")
    }
    
    private func applyFilters(_ query:String) {
        if query.isEmpty {
            viewModel.filteredRegions = viewModel.regions
        } else {
            DispatchQueue.global(qos: .userInitiated).async {
                let results = viewModel.filteredRegions.filter { $0.lowercased().contains(query.lowercased()) }
                DispatchQueue.main.async {
                    viewModel.filteredRegions = results
                }
            }
        }
    }
    
  
}


//#Preview {
//    RegionListView()
//}
