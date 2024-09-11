//
//  LocalizedString.swift
//  Unsplashify
//
//  Created by Александра Среднева on 7.09.24.
//

import Foundation

enum LocalizedString {

    enum HomePageViewController {
        static let noPhotos = String(localized: "NoPhotosFound.String")
        static let loadingPhotos = String(localized: "LoadingPhotos.String")
        static let enterText = String(localized: "EnterText.String")
    }
     enum PhotoDetailsPresenter {

         static let permissionDeniedTitle = String(localized: "PermissionDeniedTitle.String")
         static let permissionDeniedMessage = String(localized: "PermissionDeniedMessage.String")
         static let successTitle = String(localized: "SuccessTitle.String")
         static let successfulSaveMessage = String(localized: "SuccessfulSaveMessage.String")
         static let settingsAction = String(localized: "SettingsAction.String")
         static let cancelAction = String(localized: "CancelAction.String")
     }

     enum PhotoDetailsViewController {
         static let saveButtonTitle = String(localized: "SaveButtonTitle.String")
     }
 }
