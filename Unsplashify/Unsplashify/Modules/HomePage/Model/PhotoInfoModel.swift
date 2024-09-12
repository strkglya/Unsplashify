//
//  PhotoInfoModel.swift
//  Unsplashify
//
//  Created by Александра Среднева on 8.09.24.
//

import UIKit

struct PhotoInfoModel {
    var image: UIImage?
    let authorName: String
    let description: String
    let likes: Int
    let location: String?
    let bio: String?

    var formattedLikes: String {
        if likes >= 1000 {
            let formatted = Double(likes) / 1000
            return String(format: "%.1fK", formatted)
        } else {
            return "\(likes)"
        }
    }

    var formattedDescription: String {
        return description.prefix(1).uppercased() + description.dropFirst().lowercased()
    }
}
