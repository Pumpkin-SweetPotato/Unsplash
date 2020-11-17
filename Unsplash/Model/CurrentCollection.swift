//
//  CurrentCollection.swift
//  Unsplash
//
//  Created by eazel7 on 2020/11/17.
//

import Foundation

// MARK: - CurrentUserCollection
struct CurrentUserCollection: Codable {
    let id: Int
    let title: String
    let publishedAt, lastCollectedAt, updatedAt: Date
    let coverPhoto: Photo
    let user: User

    enum CodingKeys: String, CodingKey {
        case id, title
        case publishedAt = "published_at"
        case lastCollectedAt = "last_collected_at"
        case updatedAt = "updated_at"
        case coverPhoto = "cover_photo"
        case user
    }
}
