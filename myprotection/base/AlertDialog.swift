//
//  AlertDialog.swift
//  alarmbutton
//
//  Created by Rubeg NPO on 18/06/2020.
//  Copyright © 2020 Rubeg NPO. All rights reserved.
//

import UIKit

protocol AlertDialog: UIViewController {
    func showAlertDialog(title: String, message: String, completion: ((UIAlertAction) -> Void)?)
}

extension AlertDialog {

    func showAlertDialog(title: String, message: String, completion: ((UIAlertAction) -> Void)?) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.view.tintColor = .primaryColor

            let action = UIAlertAction(title: "OK", style: .default, handler: completion)
            alert.addAction(action)

            self.present(alert, animated: true, completion: nil)
        }
    }

    func showAlertDialog(title: String, message: String) {
        showAlertDialog(title: title, message: message, completion: nil)
    }

}
