//
//  PhotoDetailsBuilder.swift
//  Unsplashify
//
//  Created by Александра Среднева on 9.09.24.
//

import UIKit

// TODO: Revove after merge
protocol Presentable {
    func toPresent() -> UIViewController
}

final class PhotoDetailsBuilder: Presentable {

    // MARK: - Properties

    private var context: PhotoInfoModel

    // MARK: - Initializer

    init(context: PhotoInfoModel) {
        self.context = context
    }
    
    // MARK: - Methods

    func toPresent() -> UIViewController {
        let viewController = PhotoDetailsViewController()
        let presenter = PhotoDetailsPresenter(
            viewController: viewController,
            model: context
        )
        viewController.set(presenter: presenter)
        return viewController
    }
}
