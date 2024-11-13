//
//  HistoryView.swift
//  iPTV
//
//  Created by Gaurav Kumar on 11/12/24.
//

import SwiftUI

enum SortOption:String, CaseIterable {
    case dateAdded = "Date Added"
    case label = "Label"
    case frequency = "Frequency"
}

struct HistoryView: View {
    @EnvironmentObject var historyManager:HistoryManager
    @State private var editingLinkID:UUID?
    @State private var sortOption:SortOption = .dateAdded
    @State private var showShareSheet = false  // Controls share sheet presentation
    @State private var shareContent: [Any] = []  // Content to share
    @FocusState private var isEditing:Bool
    @EnvironmentObject var streamManager: StreamManager
    @Binding var selectedTab: AppTab
    
    var sortedLinks: [HistoryLink] {
            switch sortOption {
            case .dateAdded:
                return historyManager.recentLinks.sorted { $0.dateAdded > $1.dateAdded }
            case .label:
                return historyManager.recentLinks.sorted { $0.label.lowercased() < $1.label.lowercased() }
            case .frequency:
                return historyManager.recentLinks.sorted { $0.usageCount > $1.usageCount }
            }
        }
    
    var body: some View {
        NavigationView{
            VStack {
                Picker("Sort by", selection: $sortOption) {
                    ForEach(SortOption.allCases, id:\.self) {option in
                        Text(option.rawValue).tag(option)
                        
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                List{
                    ForEach(historyManager.recentLinks) { link in
                        VStack(alignment:.leading) {
                            HStack {
                                if editingLinkID == link.id {
                                    TextField("Label",
                                        text: Binding(
                                        get: { link.label },
                                        set: {newValue in
                                            historyManager.updateLabel(for: link.id, newLabel: newValue)
                                        }
                                    ))
                                    .focused($isEditing)
                                    .onSubmit{
                                        editingLinkID = nil
                                        isEditing = false
                                    }
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                }else {
                                    Text(link.label.isEmpty ? "Untitled Link": link.label)
                                        .font(.headline)
                                        .onTapGesture {
                                            editingLinkID = link.id
                                        }
                                }
                            }
              
                            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                deleteAction(for: link)
                                shareAction(for: link)
                            }
                            
                            
                            Text(link.url)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        .padding(.vertical, 5)
                        .onTapGesture {
                            historyManager.incrementUsageCount(for: link.id)
                            navigateToStream(with: link)
                        }
                    }
                    
                }
                
            }
            .navigationTitle("History")
            .sheet(isPresented: $showShareSheet) {
                       ActivityView(activityItems: shareContent)
                   }
        }
      
    }
    
    private func deleteAction(for link: HistoryLink) -> some View {
            Button(role: .destructive) {
                if let index = historyManager.recentLinks.firstIndex(of: link) {
                    historyManager.recentLinks.remove(at: index)
                }
            } label: {
                Label("Delete", systemImage: "trash")
            }
        }

        private func shareAction(for link: HistoryLink) -> some View {
            Button {
                shareContent = [link.url]  // Set content to share
                showShareSheet = true      // Trigger share sheet
            } label: {
                Label("Share", systemImage: "square.and.arrow.up")
            }
            .tint(.blue)  // Set a custom color for the share action
        }
    
    private func navigateToStream(with link: HistoryLink) {
        print("Navigating to Stream tab with link: \(link.url)")
        streamManager.currentLink = link.url
        selectedTab = .stream
    }
    
    private func deleteLink(at offsets:IndexSet) {
        offsets.forEach { index in
            historyManager.deleteLink(at: index)
            
        }
    }
}

//#Preview {
//    HistoryView()
//}
