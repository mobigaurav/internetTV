//
//  LanguageListView.swift
//  iPTV
//
//  Created by Gaurav Kumar on 10/31/24.
//

import SwiftUI

struct LanguageListView: View {
    @State private var searchText = ""
    @ObservedObject var viewModel = LanguageViewModel()
    @ObservedObject var purchaseManager: PurchaseManager
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    var body: some View {
        VStack {
            if viewModel.isLoading {
                ProgressView("Loading Languages...")
                    .padding()
            } else {
                // Search Bar
                TextField("Search Languages...", text: $searchText)
                    .padding(10)
                    .background(Color(.systemGray5))
                    .cornerRadius(8)
                    .padding([.horizontal, .top])
                    .onSubmit{
                        self.applyFilters(searchText)
                    }
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(viewModel.filteredLang, id: \.self) { language in
                            NavigationLink(
                                destination: {
                                    ChannelListView(filterType: .language(language), purchaseManager: purchaseManager)
                                }
                            ) {
                                CategoryCardView(category: language)
                            }
                            .buttonStyle(PlainButtonStyle())
                          
                        }
                    }
                    .padding()
                }
            }
        }
        .navigationTitle("Languages")
    }
    
    private func applyFilters(_ query:String) {
        if query.isEmpty {
            viewModel.filteredLang = viewModel.languages
        } else {
            DispatchQueue.global(qos: .userInitiated).async {
                let results = viewModel.languages.filter { $0.lowercased().contains(query.lowercased()) }
                DispatchQueue.main.async {
                    viewModel.filteredLang = results
                }
            }
        }
    }
}


//#Preview {
//    LanguageListView()
//}
