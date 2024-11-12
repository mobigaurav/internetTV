//
//  HistoryManager.swift
//  iPTV
//
//  Created by Gaurav Kumar on 11/12/24.
//

import Foundation
import Combine

struct HistoryLink: Identifiable, Codable {
    let id = UUID()
    var url: String
    var label: String
    var dateAdded: Date = Date()
    var usageCount: Int = 0  // New property to track usage frequency
}

class HistoryManager:ObservableObject {
    @Published var recentLinks:[HistoryLink] = []
    private let historyKey = "iptvHistoryLinks"
    
    init(){
        loadHistory()
    }
    
    func incrementUsageCount(for linkID: UUID) {
            if let index = recentLinks.firstIndex(where: { $0.id == linkID }) {
                recentLinks[index].usageCount += 1
                saveHistory()
            }
        }
    
    func addLink(_ url:String, label:String = "") {
        guard !recentLinks.contains(where: { $0.url == url}) else {return}
        recentLinks.insert(HistoryLink(url: url, label: label), at: 0)
        saveHistory()
    }
    
    func updateLabel(for linkId:UUID, newLabel:String) {
        if let index = recentLinks.firstIndex(where: {$0.id == linkId}) {
            recentLinks[index].label = newLabel
            saveHistory()
        }
    }
    
    func deleteLink(at index:Int) {
        recentLinks.remove(at: index)
        saveHistory()
    }
    
    func saveHistory() {
        if let encoded = try? JSONEncoder().encode(recentLinks) {
            UserDefaults.standard.set(encoded, forKey: historyKey)
        }
        
    }
    
    func loadHistory() {
        if let savedData = UserDefaults.standard.data(forKey: historyKey),
            let savedLinks = try? JSONDecoder().decode([HistoryLink].self, from: savedData) {
                recentLinks = savedLinks
            }
    }
}
