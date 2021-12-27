//
//  UISecureTextField.swift
//  myprotection
//
//  Created by Rubeg NPO on 23.07.2020.
//  Copyright © 2020 Rubeg NPO. All rights reserved.
//

import UIKit

class UISecureTextField: UITextField {

    override func becomeFirstResponder() -> Bool {
        guard
            super.becomeFirstResponder(),
            isSecureTextEntry == true,
            let existingText = text
        else {
            return true
        }

        deleteBackward()
        insertText(existingText)
        return true
    }

}
