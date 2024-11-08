//
//  M3UParser.swift
//  iPTV
//
//  Created by Gaurav Kumar on 10/31/24.
//

import Foundation

struct ChannelInfo: Identifiable, Codable, Hashable {
    var id:UUID = UUID()
    let name: String
    let url: URL
//    let category: String?
//    let language: String?
//    let country:String?
//    let region: String?
    let groupTitle: String?
    let logoURL:URL?
    var isFavorite: Bool = false  // Track favorite status
}
class M3UParser {
    static func parse(_ data: String) -> [ChannelInfo] {
        var channels = [ChannelInfo]()
        let lines = data.components(separatedBy: .newlines)
        
        var currentName: String?
        var currentURL: URL?
        var currentGroupTitle: String?
        var currentLogoURL: URL?

        for line in lines {
            if line.hasPrefix("#EXTINF") {
                // Extract name, group-title, and logo attributes
                if let nameRange = line.range(of: ",") {
                    currentName = String(line[nameRange.upperBound...]).trimmingCharacters(in: .whitespaces)
                }
                currentGroupTitle = extractAttributeValue(from: line, attribute: "group-title")
                if let logoString = extractAttributeValue(from: line, attribute: "tvg-logo") {
                    currentLogoURL = URL(string: logoString)
                }
                
            } else if line.hasPrefix("http") {
                // Capture the URL on lines that start with "http"
                currentURL = URL(string: line.trimmingCharacters(in: .whitespaces))
                
                // Create a ChannelInfo object if name and URL are available
                if let name = currentName, let url = currentURL {
                    let channel = ChannelInfo(
                        name: name,
                        url: url,
                        groupTitle: currentGroupTitle,
                        logoURL: currentLogoURL
                    )
                    channels.append(channel)
                }
                
                // Reset for the next channel entry
                currentName = nil
                currentURL = nil
                currentGroupTitle = nil
                currentLogoURL = nil
            }
        }
        return channels
    }

    private static func extractAttributeValue(from line: String, attribute: String) -> String? {
        guard let startRange = line.range(of: "\(attribute)=\"")?.upperBound else { return nil }
        let remaining = line[startRange...]
        if let endRange = remaining.range(of: "\"") {
            return String(remaining[..<endRange.lowerBound])
        }
        return nil
    }
}




