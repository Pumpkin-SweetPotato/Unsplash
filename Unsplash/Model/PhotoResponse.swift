//
//  PhotoResponse.swift
//  Unsplash
//
//  Created by Minsoo Kim on 2020/11/20.
//

import Foundation

protocol PaginationResponse {
    var isLastPage: Bool { get set }
}

struct PhotoResponse: Codable, PaginationResponse {
    let photos: [Photo]
    var isLastPage: Bool = false
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        photos = try container.decode([Photo].self)
    }
}


