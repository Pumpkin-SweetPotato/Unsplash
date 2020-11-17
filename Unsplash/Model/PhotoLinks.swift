//
//  WelcomeLinks.swift
//  Unsplash
//
//  Created by eazel7 on 2020/11/17.
//

import Foundation

// MARK: - WelcomeLinks
struct PhotoLinks: Codable {
    let linksSelf, html, download, downloadLocation: String

    enum CodingKeys: String, CodingKey {
        case linksSelf = "self"
        case html, download
        case downloadLocation = "download_location"
    }
}
