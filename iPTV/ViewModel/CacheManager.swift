//
//  CacheManager.swift
//  iPTV
//
//  Created by Gaurav Kumar on 10/30/24.
//

import Foundation

class CacheManager {
    private static let fileManager = FileManager.default
    private static let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
    static let shared = CacheManager()
    private init() {}
    
    func saveChannels(_ channels: [ChannelInfo], forKey key: String) {
            if let encoded = try? JSONEncoder().encode(channels) {
                UserDefaults.standard.set(encoded, forKey: key)
            }
        }

    func loadChannels(forKey key: String) -> [ChannelInfo]? {
        if let data = UserDefaults.standard.data(forKey: key),
           let decoded = try? JSONDecoder().decode([ChannelInfo].self, from: data) {
            return decoded
        }
        return nil
    }
    
    func saveCategory(_ channels: [String], forKey key: String) {
            if let encoded = try? JSONEncoder().encode(channels) {
                UserDefaults.standard.set(encoded, forKey: key)
            }
        }

    func loadCategory(forKey key: String) -> [String]? {
        if let data = UserDefaults.standard.data(forKey: key),
           let decoded = try? JSONDecoder().decode([String].self, from: data) {
            return decoded
        }
        return nil
    }
    
    func saveCountry(_ channels: [String], forKey key: String) {
            if let encoded = try? JSONEncoder().encode(channels) {
                UserDefaults.standard.set(encoded, forKey: key)
            }
        }

    func loadCountry(forKey key: String) -> [String]? {
        if let data = UserDefaults.standard.data(forKey: key),
           let decoded = try? JSONDecoder().decode([String].self, from: data) {
            return decoded
        }
        return nil
    }
    
    func saveRegion(_ channels: [String], forKey key: String) {
            if let encoded = try? JSONEncoder().encode(channels) {
                UserDefaults.standard.set(encoded, forKey: key)
            }
        }

    func loadRegion(forKey key: String) -> [String]? {
        if let data = UserDefaults.standard.data(forKey: key),
           let decoded = try? JSONDecoder().decode([String].self, from: data) {
            return decoded
        }
        return nil
    }
    
    func saveLanguage(_ channels: [String], forKey key: String) {
            if let encoded = try? JSONEncoder().encode(channels) {
                UserDefaults.standard.set(encoded, forKey: key)
            }
        }

    func loadLanguage(forKey key: String) -> [String]? {
        if let data = UserDefaults.standard.data(forKey: key),
           let decoded = try? JSONDecoder().decode([String].self, from: data) {
            return decoded
        }
        return nil
    }
    
    // Save JSON data to a file in the documents directory
    static func save<T: Encodable>(_ object: T, to filename: String) {
        let fileURL = documentsDirectory.appendingPathComponent(filename)
        do {
            let data = try JSONEncoder().encode(object)
            try data.write(to: fileURL)
            print("Data saved to \(filename)")
        } catch {
            print("Error saving data to \(filename): \(error)")
        }
    }

    // Load JSON data from a file in the documents directory
    static func load<T: Decodable>(_ type: T.Type, from filename: String) -> T? {
        let fileURL = documentsDirectory.appendingPathComponent(filename)
        do {
            let data = try Data(contentsOf: fileURL)
            let object = try JSONDecoder().decode(type, from: data)
            print("Data loaded from \(filename)")
            return object
        } catch {
            print("Error loading data from \(filename): \(error)")
            return nil
        }
    }

    // Check if a file exists in the documents directory
    static func fileExists(_ filename: String) -> Bool {
        let fileURL = documentsDirectory.appendingPathComponent(filename)
        return fileManager.fileExists(atPath: fileURL.path)
    }
}

