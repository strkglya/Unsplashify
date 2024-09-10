//
//  PhotoDetailsPresenter.swift
//  Unsplashify
//
//  Created by Александра Среднева on 9.09.24.
//

import UIKit
import Photos

protocol PhotoDetailsPresenterProtocol {
    func saveImage(image: UIImage)
    func getImage()
    func shareImage()
}

final class PhotoDetailsPresenter: PhotoDetailsPresenterProtocol {

    // MARK: - Properties

    private weak var viewController: PhotoDetailsViewControllerProtocol?
    private var model: PhotoInfoModel

    // MARK: - Initializer

    init(
        viewController: PhotoDetailsViewControllerProtocol,
        model: PhotoInfoModel
    ) {
        self.viewController = viewController
        self.model = model
    }

    // MARK: - Methods

    func getImage() {
        viewController?.update(model: model)
    }

    func shareImage() {
        let activityIndicator = UIActivityViewController(
            activityItems: [model.image],
            applicationActivities: nil
        )
        activityIndicator.completionWithItemsHandler = { [weak self] activity, success, _, _ in
            guard let self = self else { return }
            if activity == .saveToCameraRoll {
               showSuccessfullSaveAlert()
            }
        }
        viewController?.present(controller: activityIndicator)
    }

    func saveImage(image: UIImage) {
        checkPhotoLibraryPermission { [weak self] granted in
            guard let self = self else { return }
            guard granted else {
                self.showPermissionAlert()
                return
            }

            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
            showSuccessfullSaveAlert()
        }
    }

    // MARK: - Private Methods

    private func checkPhotoLibraryPermission(completion: @escaping (Bool) -> Void) {
        let status = PHPhotoLibrary.authorizationStatus()

        switch status {
        case .authorized:
            completion(true)
        case .denied, .restricted:
            completion(false)
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { newStatus in
                completion(newStatus == .authorized)
            }
        default:
            completion(false)
        }
    }

    private func showSuccessfullSaveAlert() {
        let alert = AlertManager.createAlert(
            title: LocalizedString.PhotoDetailsPresenter.successTitle,
            message: LocalizedString.PhotoDetailsPresenter.successfulSaveMessage
        )
        viewController?.present(controller: alert)
    }

    private func showPermissionAlert() {
        let alert = AlertManager.createAlert(
            title: LocalizedString.PhotoDetailsPresenter.permissionDeniedTitle,
            message: LocalizedString.PhotoDetailsPresenter.permissionDeniedMessage,
            actions: [
                UIAlertAction(
                    title: LocalizedString.PhotoDetailsPresenter.cancelAction,
                    style: .cancel
                ),
                UIAlertAction(
                    title: LocalizedString.PhotoDetailsPresenter.settingsAction,
                    style: .default
                ) { _ in
                    guard let appSettings = URL(string: UIApplication.openSettingsURLString) else { return }
                    UIApplication.shared.open(appSettings)
                }
            ]
        )
        viewController?.present(controller: alert)
    }
}
