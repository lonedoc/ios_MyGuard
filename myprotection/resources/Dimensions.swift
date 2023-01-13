//
//  Dimensions.swift
//  myprotection
//
//  Created by Rubeg NPO on 30.12.2022.
//  Copyright © 2022 Rubeg NPO. All rights reserved.
//

import Foundation
import UIKit

class Dimensions {

    static let defaultValues = lightAppearance

    static let lightAppearance = Dimensions(
        textFieldHorizontalPadding: 16
    )

    static let darkAppearance = Dimensions(
        textFieldHorizontalPadding: 0
    )

    // MARK: Common
    let windowPadding: CGFloat = 16
    let oneLineTextFieldHeight: CGFloat = 44
    let textFieldHorizontalPadding: CGFloat
    let textFieldCornerRadius: CGFloat = 12
    let dropdownIconSize: CGFloat = 12
    let buttonHeight: CGFloat = 56
    let buttonCornerRadius: CGFloat = 16
    
    private init(textFieldHorizontalPadding: CGFloat) {
        self.textFieldHorizontalPadding = textFieldHorizontalPadding
    }

}

extension UIView {

    var dimensions: Dimensions {
        if isDarkMode {
            return Dimensions.darkAppearance
        }
        
        return Dimensions.lightAppearance
    }

}
