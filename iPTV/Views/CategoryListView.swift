//
//  CategoryListView.swift
//  iPTV
//
//  Created by Gaurav Kumar on 10/31/24.
//

import SwiftUI


struct CategoryListView: View {
    @State private var selectedCategory: String?
    @State private var searchText = ""
    @ObservedObject var viewModel = CategoryViewModel()
    @ObservedObject var purchaseManager: PurchaseManager
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    var body: some View {
            VStack {
                if viewModel.isLoading {
                    ProgressView("Loading Categories...")
                        .padding()
                } else {
                    // Search Bar
                    TextField("Search categories...", text: $searchText)
                        .padding(10)
                        .background(Color(.systemGray5))
                        .cornerRadius(8)
                        .padding([.horizontal, .top])
                        .onSubmit{
                            self.applyFilters(searchText)
                        }
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 20) {
                            ForEach(viewModel.filteredCategories, id: \.self) { category in
                                NavigationLink(
                                    destination: {
                                        ChannelListView(filterType: .category(category), purchaseManager: purchaseManager)
                                    }
                                ) {
                                    CategoryCardView(category: category)
                                }
                                .buttonStyle(PlainButtonStyle())
                              
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("Categories")
    }
    
    private func applyFilters(_ query:String) {
        if query.isEmpty {
            viewModel.filteredCategories = viewModel.categories
        } else {
            DispatchQueue.global(qos: .userInitiated).async {
                let results = viewModel.filteredCategories.filter { $0.lowercased().contains(query.lowercased()) }
                DispatchQueue.main.async {
                    viewModel.filteredCategories = results
                }
            }
        }
    }
    
   
}



//#Preview {
//    CategoryListView()
//}
