//
//  UIColorExtensions.swift
//  alarmbutton
//
//  Created by Rubeg NPO on 02/06/2020.
//  Copyright © 2020 Rubeg NPO. All rights reserved.
//

import UIKit

extension UIColor {

    static let primaryColor = UIColor(red: 0.30, green: 0.69, blue: 0.31, alpha: 1.00)
    static let primaryColorPale = UIColor(red: 0.51, green: 0.78, blue: 0.52, alpha: 1.00)
    static let secondaryColor = UIColor(red: 0.13, green: 0.59, blue: 0.95, alpha: 1.00)
    static let secondaryColorPale = UIColor(red: 0.39, green: 0.71, blue: 0.96, alpha: 1.00)
    static let errorColor = UIColor(red: 1.00, green: 0.34, blue: 0.13, alpha: 1.00)
    static let errorColorPale = UIColor(red: 1.00, green: 0.54, blue: 0.40, alpha: 1.00)
    static var darkBackgroundColor = UIColor(red: 0.32, green: 0.35, blue: 0.38, alpha: 1.00)

    static let alarmStatusColor = errorColor
    static let malfunctionStatusColor = UIColor(red: 0.47, green: 0.33, blue: 0.28, alpha: 1.00)
    static let malfunctionStatusColorAlt = UIColor(red: 1.00, green: 0.92, blue: 0.23, alpha: 1.00)
    static let notGuardedStatusColor = primaryColor
    static let guardedStatusColor = secondaryColor
    static let unknownStatusColor = UIColor.gray

    static var mainBackgroundColor: UIColor {
        return UIColor(named: "main_background_color") ?? .white
    }

    static var backgroundColor: UIColor {
        return UIColor(named: "background_color") ?? .white
    }

    static var contrastTextColor: UIColor {
        return UIColor(named: "contrast_text_color") ?? .black
    }

    static var paleTextColor: UIColor {
        return UIColor(named: "pale_text_color") ?? .gray
    }

    static var screenBackgroundColor: UIColor {
        return UIColor(named: "screen_background_color") ?? .white
    }

    static var screenForegroundColor: UIColor {
        return UIColor(named: "screen_foreground_color") ?? .gray
    }

    static var surfaceBackgroundColor: UIColor {
        return UIColor(named: "surface_background_color") ?? .lightGray
    }

    static var surfaceForegroundColor: UIColor {
        return UIColor(named: "surface_foreground_color") ?? .black
    }

}
