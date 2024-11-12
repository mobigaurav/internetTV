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
                                
                                Spacer()
                                
                                // Share Button
                                Button(action: {
                                    showShareSheet = true      // Show the share sheet
                                }) {
                                    Image(systemName: "square.and.arrow.up")
                                        .foregroundColor(.blue)
                                }
                                .sheet(isPresented: $showShareSheet) {
                                    ActivityView(activityItems: [URL(string: link.url) ?? ""])
                                }
                               
                
                            }
                           
                            
                            Text(link.url)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        .padding(.vertical, 5)
                        .onTapGesture {
                            historyManager.incrementUsageCount(for: link.id)
                        }
                    }
                    .onDelete(perform: deleteLink)
                    
                }
                
            }
            .navigationTitle("History")
        }
      
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
