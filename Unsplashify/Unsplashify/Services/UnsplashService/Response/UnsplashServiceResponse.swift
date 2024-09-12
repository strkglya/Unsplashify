//
//  UnsplashServiceResponse.swift
//  Unsplashify
//
//  Created by Александра Среднева on 8.09.24.
//

import Foundation

struct UnsplashSearchResponse: Codable {
    let results: [UnsplashServiceResponse]
}

struct UnsplashServiceResponse: Codable {

    let description: String
    let likes: Int
    let urls: Urls
    let user: User

    enum CodingKeys: String, CodingKey {
        case urls, user, likes
        case description = "alt_description"
    }
}

struct User: Codable, Hashable {
    let name: String
    let location: String?
    let bio: String?
}

// MARK: - Urls
struct Urls: Codable, Hashable {

    let regular: String
    let small: String
    let thumb: String
}
