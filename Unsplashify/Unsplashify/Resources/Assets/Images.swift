//
//  Resources.swift
//  Unsplashify
//
//  Created by Александра Среднева on 7.09.24.
//

import UIKit

enum Images {

    enum PhotoDetailsViewController {
        case share

        var image: UIImage? {
            switch self {
            case .share:
                return UIImage(systemName: "square.and.arrow.up")
            }
        }
    }

    enum RecentSearchesTableViewCell {
        case recent

        var image: UIImage? {
            switch self {
            case .recent:
                return UIImage(systemName: "clock.arrow.circlepath")
            }
        }
    }

    enum HomePageCollectionCell {
        case heart

        var image: UIImage? {
            switch self {
            case .heart:
                return UIImage(systemName: "heart")
            }
        }
    }

    enum HomePageViewController {
        case sortIcon
        case gridIconForOne
        case gridIconForTwo


        var image: UIImage? {
            switch self {
            case .sortIcon:
                return UIImage(systemName: "arrow.up.arrow.down")
            case .gridIconForOne:
                return UIImage(systemName: "rectangle.grid.1x2")
            case .gridIconForTwo:
                return UIImage(systemName: "rectangle.grid.2x2")
            }
        }
    }
}
