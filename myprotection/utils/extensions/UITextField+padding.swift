//
//  UITextFieldExtensions.swift
//  myprotection
//
//  Created by Rubeg NPO on 17.02.2021.
//  Copyright © 2021 Rubeg NPO. All rights reserved.
//

import UIKit

extension UITextField {

    func setLeftPadding(_ padding: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: padding, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }

    func setRightPadding(_ padding: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: padding, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }

}
