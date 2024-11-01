//
//  Guide.swift
//  iPTV
//
//  Created by Gaurav Kumar on 10/25/24.
//

import Foundation
struct Guide: Codable {
    let channel: String
    let site: String
    let siteID: String
    let siteName: String
    let lang: String?
}
