//
//  ChannelListView.swift
//  iPTV
//
//  Created by Gaurav Kumar on 10/25/24.
//

import SwiftUI

struct IdentifiableURL: Identifiable {
    let id = UUID()
    let url: URL
}

struct ChannelListViewOld: View {
    @ObservedObject var viewModel: ChannelViewModel
    //var category: Category
    @State private var selectedStream: IdentifiableURL?
    
    var body: some View {
        NavigationView {
            VStack {
                TextField("Search Channels...", text: $viewModel.searchText)
                    .padding(10)
                    .background(Color(.systemGray5))
                    .cornerRadius(8)
                    .padding([.horizontal, .top])
                    .onSubmit {
                        viewModel.applyFilters()
                    }
                

                ScrollView {
                    VStack(spacing: 15) {
                        ForEach(viewModel.channels) { channel in
                            ChannelRow(channel: channel,
                                       viewModel: viewModel,
                                       selectedStream: $selectedStream,
                                       isFavorite: Binding(
                                        get: { channel.isFavorite },
                                        set: { newValue in
                                            viewModel.toggleFavorite(for: channel)
                                        }
                                       ))
                            .padding(.horizontal)
                        }
                        
                    }
                    .padding(.top)
                }
//                .onAppear {
//                    // Filter channels by selected category when this category is navigated to
//                    viewModel.searchText = ""
//                    viewModel.filterChannels(by: category.id)
//                }
            }
            
            .background(Color(UIColor.systemGroupedBackground))
           // .navigationTitle(category.name)
            .sheet(item: $selectedStream) { identifiableURL in
                PlayerView(streamURL: identifiableURL.url)
            }
        }
    }
}



// Extract ChannelRow into a separate component
struct ChannelRow: View {
    let channel: Channel
    var viewModel: ChannelViewModel
    @Binding var selectedStream: IdentifiableURL?
    @Binding var isFavorite: Bool
    
    var body: some View {
        Button(action: {
            if let streamURL = channel.streams?.first?.url {
                selectedStream = IdentifiableURL(url: streamURL)
            }
        }) {
            HStack {
                ChannelImageView(url: channel.logoURL)
                
                // Channel Title
                Text(channel.name)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Spacer()
                
                Button(action: {
                    viewModel.toggleFavorite(for: channel)
                }) {
                    Image(systemName: channel.isFavorite ? "star.fill" : "star")
                        .foregroundColor(channel.isFavorite ? .yellow : .gray)
                }
            }
            .padding()
            .background(Color.white)
            .cornerRadius(12)
            .shadow(radius: 4)
        }
        .buttonStyle(PlainButtonStyle())  // Remove default button style
    }
}

// Extract ChannelImageView into a separate view
struct ChannelImageView: View {
    let url: URL?
    
    var body: some View {
        AsyncImage(url: url) { image in
            image.resizable()
        } placeholder: {
            Color.gray
        }
        .frame(width: 50, height: 50)
        .cornerRadius(8)
    }
}


//
//#Preview {
//    let sampleViewModel = ChannelViewModel()
////    ChannelListView(viewModel: sampleViewModel ,
////                    category: Category(id: "Animation", name: "Animation"))
//    ChannelListView(viewModel: sampleViewModel)
//}
