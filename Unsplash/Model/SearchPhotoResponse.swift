//
//  SearchPhotoResponse.swift
//  Unsplash
//
//  Created by eazel7 on 2020/11/17.
//

import Foundation

struct SearchPhotoResponse: Codable {
    let total: Int
    let totalPages: Int
    let results: [Photo]
    
    enum CodingKeys: String, CodingKey {
        case total
        case totalPages = "total_pages"
        case results
    }
}
