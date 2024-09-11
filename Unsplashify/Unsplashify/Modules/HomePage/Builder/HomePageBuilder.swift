//
//  HomePageBuilder.swift
//  Unsplashify
//
//  Created by Александра Среднева on 8.09.24.
//

import UIKit

protocol Presentable {
    func toPresent() -> UIViewController
}

final class HomePageBuilder: Presentable {

    func toPresent() -> UIViewController {

        let networkService = BaseNetworkService()
        let unsplashService = UnsplashService(networkService: networkService)
        let viewController = HomePageViewController()
        let userDefaults = UserDefaultsManager()
        let presenter = HomePagePresenter(viewController: viewController, userDefaultsManager: userDefaults)
        presenter.set(service: unsplashService)
        viewController.set(presenter: presenter)

        return viewController
    }
}
