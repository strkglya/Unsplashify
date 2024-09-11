//
//  UserDefaultsManager.swift
//  Unsplashify
//
//  Created by Александра Среднева on 11.09.24.
//

import Foundation

protocol UserDefaultsManagerProtocol {
    var recentSearches: [String] { get set }
}


final class UserDefaultsManager: UserDefaultsManagerProtocol {

    private enum Keys {
        static let recentSearches = "RecentSearches"
    }

    var recentSearches: [String] {
        get {
            guard let searches = UserDefaults.standard.array(forKey: "RecentSearches") as? [String] else {
                return []
            }
            return searches
        }
        set {
            return UserDefaults.standard.set(newValue, forKey: Keys.recentSearches)
        }
    }
}
