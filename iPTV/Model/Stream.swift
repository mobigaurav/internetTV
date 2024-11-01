//
//  Stream.swift
//  iPTV
//
//  Created by Gaurav Kumar on 10/25/24.
//

import Foundation
struct Stream: Codable {
    let channel: String
    let url:URL
    let httpReferrer: String?
    let userAgent: String?
}
