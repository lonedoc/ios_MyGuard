//
//  AlertDialog.swift
//  alarmbutton
//
//  Created by Rubeg NPO on 18/06/2020.
//  Copyright © 2020 Rubeg NPO. All rights reserved.
//

import UIKit

protocol AlertDialog: UIViewController {}

extension AlertDialog {
    func showAlertDialog(
        title: String,
        message: String,
        completion: ((UIAlertAction) -> Void)? = nil
    ) {
        showAlertDialog(
            title: title,
            message: message,
            completion: completion
        )
    }
}
