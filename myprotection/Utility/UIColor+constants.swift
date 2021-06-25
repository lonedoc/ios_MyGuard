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

    static var defaultBackgroundColor: UIColor {
        get {
            if #available(iOS 13.0, *) {
                return .systemGray5
            } else {
                return UIColor(red: 0.93, green: 0.93, blue: 0.93, alpha: 1.00)
            }
        }
    }

    static var contrastBackgroundColor: UIColor {
        get {
            if #available(iOS 13.0, *) {
                return .systemGray6
            } else {
                return UIColor(red: 0.98, green: 0.98, blue: 0.98, alpha: 1.00)
            }
        }
    }

    static var defaultTextColor: UIColor {
        get {
            if #available(iOS 13.0, *) {
                return .secondaryLabel
            } else {
                return UIColor(red: 0.26, green: 0.26, blue: 0.26, alpha: 1.00)
            }
        }
    }

    static var contrastTextColor: UIColor {
        get {
            if #available(iOS 13.0, *) {
                return .label
            } else {
                return UIColor(red: 0.13, green: 0.13, blue: 0.13, alpha: 1.00)
            }
        }
    }

}
