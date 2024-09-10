//
//  AlertManager.swift
//  Unsplashify
//
//  Created by Александра Среднева on 9.09.24.
//

import Foundation
import UIKit

final class AlertManager {

    static func createAlert(
        title: String,
        message: String,
        actions: [UIAlertAction] = [UIAlertAction(title: "ОК", style: .default)]
    ) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        actions.forEach { alert.addAction($0) }
        return alert
    }
}
