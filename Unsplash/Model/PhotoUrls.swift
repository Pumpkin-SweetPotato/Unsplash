//
//  PhotoUrls.swift
//  Unsplash
//
//  Created by eazel7 on 2020/11/17.
//

import Foundation

// MARK: - Urls
struct PhotoUrls: Codable {
    let raw, full, regular, small: String
    let thumb: String
}
