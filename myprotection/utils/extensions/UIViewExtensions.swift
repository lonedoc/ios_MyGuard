//
//  UIViewExtensions.swift
//  myprotection
//
//  Created by Rubeg NPO on 30.12.2022.
//  Copyright © 2022 Rubeg NPO. All rights reserved.
//

import UIKit

extension UIView {

    var isDarkMode: Bool {
        if #available(iOS 12.0, *) {
            return traitCollection.userInterfaceStyle == .dark
        }
        
        return false
    }

}
