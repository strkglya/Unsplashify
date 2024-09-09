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
}
