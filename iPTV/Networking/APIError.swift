//
//  APIError.swift
//  iPTV
//
//  Created by Gaurav Kumar on 10/25/24.
//

import Foundation

enum APIError: LocalizedError {
    case invalidURL
    case networkError(Error)
    case dataNotFound
    case decodingError(Error)
    case serverError(statusCode:Int)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "The URL is invalid."
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        case .dataNotFound:
            return "Data not found."
        case .decodingError(let error):
            return "Failed to decode data: \(error.localizedDescription)"
        case .serverError(let statusCode):
            return "Server error with status code \(statusCode)."
        }
    }
}
