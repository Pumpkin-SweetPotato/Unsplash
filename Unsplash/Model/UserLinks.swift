//
//  UserLinks.swift
//  Unsplash
//
//  Created by Minsoo Kim on 2020/11/17.
//

import Foundation

// MARK: - UserLinks
struct UserLinks: Codable {
    let linksSelf, html, photos, likes: String
    let portfolio: String

    enum CodingKeys: String, CodingKey {
        case linksSelf = "self"
        case html, photos, likes, portfolio
    }
}
