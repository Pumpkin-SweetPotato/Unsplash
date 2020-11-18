//
//  PhotoUrls.swift
//  Unsplash
//
//  Created by Minsoo Kim on 2020/11/17.
//

import Foundation

// MARK: - Urls
struct PhotoUrls: Codable {
    let raw, full, regular, small: String
    let thumb: String
}
