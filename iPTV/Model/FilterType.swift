//
//  FilterType.swift
//  iPTV
//
//  Created by Gaurav Kumar on 10/31/24.
//
import Foundation

enum FilterType {
    case category(String)
    case language(String)
    case region(String)
    case country(String)
    
    var displayName: String {
        switch self {
        case .category(let value): return "\(value)"
        case .language(let value): return "\(value)"
        case .region(let value): return "\(value)"
        case .country(let value): return "\(value)"
        }
    }
    
    var m3uURL: URL? {
        switch self {
        case .category: return URL(string: "https://iptv-org.github.io/iptv/index.category.m3u")
        case .language: return URL(string: "https://iptv-org.github.io/iptv/index.language.m3u")
        case .region: return URL(string: "https://iptv-org.github.io/iptv/index.region.m3u")
        case .country: return URL(string: "https://iptv-org.github.io/iptv/index.country.m3u")
        }
    }
}

