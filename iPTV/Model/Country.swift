//
//  Country.swift
//  iPTV
//
//  Created by Gaurav Kumar on 10/25/24.
//

import Foundation
struct Country: Codable {
    let name: String
    let code: String
    let languages: [String]?
    let flag: String?
}
