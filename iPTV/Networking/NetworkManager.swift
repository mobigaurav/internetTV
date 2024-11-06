//
//  NetworkManager.swift
//  iPTV
//
//  Created by Gaurav Kumar on 10/25/24.
//

import Foundation
class NetworkManager {
    static let shared = NetworkManager()
    private init(){}
    
    private func fetch<T:Decodable>(url:URL, completion: @escaping(Result<T, APIError>) -> Void) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(.networkError(error)))
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse, !(200...299).contains(httpResponse.statusCode){
                completion(.failure(.serverError(statusCode: httpResponse.statusCode)))
                return
            }
            
            guard let data = data else {
                completion(.failure(.dataNotFound))
                return
            }
            
            do {
                let result = try JSONDecoder().decode(T.self, from: data)
                completion(.success(result))
            } catch {
                completion(.failure(.decodingError(error)))
            }
            
        }.resume()
    }
    
    // Fetch channels with dynamic URL
    func fetchAllChannels(completion: @escaping (Result<[ChannelInfo], APIError>) -> Void) {
        guard let url = URL(string: "\(Environment.baseURL)/index.m3u") else {
            completion(.failure(.invalidURL))
            return
        }
        fetch(url: url, completion: completion)
    }
    
    // Fetch channels with dynamic URL
    func fetchAllCategories(completion: @escaping (Result<[String], APIError>) -> Void) {
        guard let url = URL(string: "\(Environment.baseURL)/index.category.m3u") else {
            completion(.failure(.invalidURL))
            return
        }
        fetch(url: url, completion: completion)
    }
    
    // Fetch channels with dynamic URL
    func fetchAllCountries(completion: @escaping (Result<[Channel], APIError>) -> Void) {
        guard let url = URL(string: "\(Environment.baseURL)/index.country.m3u") else {
            completion(.failure(.invalidURL))
            return
        }
        fetch(url: url, completion: completion)
    }
    
    // Fetch channels with dynamic URL
    func fetchAllLanguages(completion: @escaping (Result<[Channel], APIError>) -> Void) {
        guard let url = URL(string: "\(Environment.baseURL)/index.language.m3u") else {
            completion(.failure(.invalidURL))
            return
        }
        fetch(url: url, completion: completion)
    }
    
    // Fetch channels with dynamic URL
    func fetchAllRegions(completion: @escaping (Result<[Channel], APIError>) -> Void) {
        guard let url = URL(string: "\(Environment.baseURL)/index.region.m3u") else {
            completion(.failure(.invalidURL))
            return
        }
        fetch(url: url, completion: completion)
    }
    
    // Fetch channels with dynamic URL
    func fetchChannelByType(completion: @escaping (Result<[Channel], APIError>) -> Void) {
        guard let url = URL(string: "\(Environment.baseURL)/index.m3u.json") else {
            completion(.failure(.invalidURL))
            return
        }
        fetch(url: url, completion: completion)
    }
    
    // Fetch channels with dynamic URL
    func fetchChannels(completion: @escaping (Result<[Channel], APIError>) -> Void) {
        guard let url = URL(string: "\(Environment.baseURL)/index.m3u.json") else {
            completion(.failure(.invalidURL))
            return
        }
        fetch(url: url, completion: completion)
    }
    
    // Fetch channels with dynamic URL
    func fetchCountries(completion: @escaping (Result<[Country], APIError>) -> Void) {
        guard let url = URL(string: "\(Environment.baseURL)/countries.json") else {
            completion(.failure(.invalidURL))
            return
        }
        fetch(url: url, completion: completion)
    }
    
    // Fetch channels with dynamic URL
    func fetchLanguages(completion: @escaping (Result<[Language], APIError>) -> Void) {
        guard let url = URL(string: "\(Environment.baseURL)/languages.json") else {
            completion(.failure(.invalidURL))
            return
        }
        fetch(url: url, completion: completion)
    }
    
    // Fetch channels with dynamic URL
    func fetchRegions(completion: @escaping (Result<[Region], APIError>) -> Void) {
        guard let url = URL(string: "\(Environment.baseURL)/regions.json") else {
            completion(.failure(.invalidURL))
            return
        }
        fetch(url: url, completion: completion)
    }
    
    // Fetch channels with dynamic URL
    func fetchSubdivisions(completion: @escaping (Result<[Subdivision], APIError>) -> Void) {
        guard let url = URL(string: "\(Environment.baseURL)/subdivisions.json") else {
            completion(.failure(.invalidURL))
            return
        }
        fetch(url: url, completion: completion)
    }
    
    // Fetch streams with dynamic URL
    func fetchStreams(completion: @escaping (Result<[Stream], APIError>) -> Void) {
        guard let url = URL(string: "\(Environment.baseURL)/streams.json") else {
            completion(.failure(.invalidURL))
            return
        }
        fetch(url: url, completion: completion)
    }
    
    // Fetch guides with dynamic URL
    func fetchGuides(completion: @escaping (Result<[Guide], APIError>) -> Void) {
        guard let url = URL(string: "\(Environment.baseURL)/guides.json") else {
            completion(.failure(.invalidURL))
            return
        }
        fetch(url: url, completion: completion)
    }
    
    // Fetch categories
    
    func fetchCategories(completion: @escaping(Result<[Category], APIError>) -> Void) {
        guard let url = URL(string:"\(Environment.baseURL)/categories.json") else {
            completion(.failure(.invalidURL))
            return
        }
        fetch(url: url, completion: completion)
    }
    
    
    
}
