//
//  User.swift
//  Unsplash
//
//  Created by eazel7 on 2020/11/17.
//

import Foundation

// MARK: - User
struct User: Codable {
    let id, username, name: String
    let portfolioURL: String?
    let bio: String?
    let location: String?
    let totalLikes, totalPhotos, totalCollections: Int
    let instagramUsername: String?
    let twitterUsername: String?
    let profileImage: ProfileImage
    let links: UserLinks

    enum CodingKeys: String, CodingKey {
        case id, username, name
        case portfolioURL = "portfolio_url"
        case bio, location
        case totalLikes = "total_likes"
        case totalPhotos = "total_photos"
        case totalCollections = "total_collections"
        case instagramUsername = "instagram_username"
        case twitterUsername = "twitter_username"
        case profileImage = "profile_image"
        case links
    }
}
