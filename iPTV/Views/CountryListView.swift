//
//  CountryListView.swift
//  iPTV
//
//  Created by Gaurav Kumar on 10/31/24.
//

import SwiftUI

struct CountryListView: View {
    @State private var searchText = ""
    @ObservedObject var viewModel = CountryViewModel()
    @ObservedObject var purchaseManager: PurchaseManager
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    var body: some View {
        VStack {
            if viewModel.isLoading {
                ProgressView("Loading Countries...")
                    .padding()
            } else {
                // Search Bar
                TextField("Search Countries...", text: $searchText)
                    .padding(10)
                    .background(Color(.systemGray5))
                    .cornerRadius(8)
                    .padding([.horizontal, .top])
                    .onSubmit{
                        self.applyFilters(searchText)
                    }
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(viewModel.filteredCountries, id: \.self) { country in
                            NavigationLink(
                                destination: {
                                    ChannelListView(filterType: .country(country), purchaseManager: purchaseManager)
                                }
                            ) {
                                CategoryCardView(category: country)
                            }
                            .buttonStyle(PlainButtonStyle())
                          
                        }
                    }
                    .padding()
                }
            }
        }
        .navigationTitle("Countries")
    }
    
    private func applyFilters(_ query:String) {
        if query.isEmpty {
            viewModel.filteredCountries = viewModel.countries
        } else {
            DispatchQueue.global(qos: .userInitiated).async {
                let results = viewModel.filteredCountries.filter { $0.lowercased().contains(query.lowercased()) }
                DispatchQueue.main.async {
                    viewModel.filteredCountries = results
                    
                }
            }
        }
    }
    

}


//#Preview {
//    CountryListView()
//}
