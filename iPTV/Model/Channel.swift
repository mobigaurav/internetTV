//
//  Channels.swift
//  iPTV
//
//  Created by Gaurav Kumar on 10/24/24.
//

import Foundation

struct Channel: Identifiable, Codable {
    let id: String
    let name: String
    let logoURL: URL?
    let categories: [String]
    var streams: [Stream]? = []  // Associated streams
    let altNames: [String]?
    let network: String?
    let owners: [String]?
    let country: String
    let subdivision: String?
    let city: String?
    let broadcastArea: [String]?
    let languages: [String]?
    let isNsfw: Bool?
    let launched: String?
    let closed: String?
    let replacedBy: String?
    let website: String?
    var isFavorite:Bool = false
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case logoURL
        case categories
        case streams
        case altNames
        case network
        case owners
        case country
        case subdivision
        case languages
        case city
        case broadcastArea
        case isNsfw
        case launched
        case closed
        case replacedBy
        case website
            // Add other API fields here, but exclude `isFavorite`
        }
}

//struct Channel: Identifiable, Equatable {
//    let id: String
//    let name: String
//    let altNames: [String]?
//    let network: String?
//    let owners: [String]?
//    let country: String?
//    let subdivision: String?
//    let city: String?
//    let broadcastArea: [String]?
//    let languages: [String]?
//    let categories: [String]
//    let isNsfw: Bool
//    let launched: String?
//    let closed: String?
//    let replacedBy: String?
//    let website: URL?
//    let logoURL: URL?
//    var streams: [Stream] = []
//    
//    // Implement the Equatable protocol
//       static func ==(lhs: Channel, rhs: Channel) -> Bool {
//           return lhs.id == rhs.id
//       }
//}
