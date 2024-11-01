//
//  Environment.swift
//  iPTV
//
//  Created by Gaurav Kumar on 10/25/24.
//

import Foundation

enum EnvironmentType {
    case development
    case qa
    case production
}

struct Environment {
    static let current:EnvironmentType = .production
    
    private static let developmentBaseURL = "https://dev.iptv-org.github.io/api"
    private static let qaBaseURL = "https://qa.iptv-org.github.io/api"
    private static let productionBaseURL = "https://iptv-org.github.io/api"
    
    static var baseURL:String {
        switch current {
        case .development:
            return developmentBaseURL
        case .qa:
            return qaBaseURL
        case .production:
            return productionBaseURL
        }
    }
}
