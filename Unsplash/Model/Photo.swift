//
//  Photo.swift
//  Unsplash
//
//  Created by eazel7 on 2020/11/17.
//

import Foundation

struct Photo: Codable {
    let id: String
    let createdAt, updatedAt: Date
    let width, height: Int
    let color, blurHash: String
    let likes: Int
    let likedByUser: Bool
    let photoDescription: String?
    let user: User
    let currentUserCollections: [CurrentUserCollection]
    let urls: PhotoUrls
    let links: PhotoLinks

    enum CodingKeys: String, CodingKey {
        case id
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case width, height, color
        case blurHash = "blur_hash"
        case likes
        case likedByUser = "liked_by_user"
        case photoDescription = "description"
        case user
        case currentUserCollections = "current_user_collections"
        case urls, links
    }
}





// MARK: - Encode/decode helpers
