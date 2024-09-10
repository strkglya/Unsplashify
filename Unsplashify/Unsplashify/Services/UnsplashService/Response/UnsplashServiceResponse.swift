//
//  UnsplashServiceResponse.swift
//  Unsplashify
//
//  Created by Александра Среднева on 8.09.24.
//

import Foundation

struct UnsplashServiceResponse: Codable {
    let id: String
    let createdAt: String
    let width: Int
    let height: Int
    let blurHash: String?
    let description: String
    let likes: Int
    let urls: Urls
    let user: User
    let date: String

    enum CodingKeys: String, CodingKey {
        case id, width, height, urls, user, likes
        case createdAt = "created_at"
        case blurHash = "blur_hash"
        case description = "alt_description"
        case date = "updated_at"
    }
}

struct User: Codable, Hashable {
    let name: String
    let location: String?
}

// MARK: - Urls
struct Urls: Codable, Hashable {

    let regular: String
    let small: String
    let thumb: String
}
