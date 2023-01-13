//
//  UIViewControllerExtensions.swift
//  myprotection
//
//  Created by Rubeg NPO on 09.01.2023.
//  Copyright © 2023 Rubeg NPO. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {

    func showAlertDialog(
        title: String,
        message: String,
        completion: ((UIAlertAction) -> Void)? = nil
    ) {
        DispatchQueue.main.async {
            let alert = UIAlertController(
                title: title,
                message: message,
                preferredStyle: .alert
            )

            alert.view.tintColor = .primaryColor

            let action = UIAlertAction(title: "OK", style: .default, handler: completion)
            alert.addAction(action)

            self.present(alert, animated: true, completion: nil)
        }
    }

}
