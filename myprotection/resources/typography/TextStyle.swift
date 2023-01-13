//
//  TextStyle.swift
//  myprotection
//
//  Created by Rubeg NPO on 03.11.2022.
//  Copyright © 2022 Rubeg NPO. All rights reserved.
//

import Foundation
import UIKit

enum TextStyle {
    case display1
    case display2
    case paragraph
    case headline
    case digitButtonTitle
    case caption4
    case caption3
    case caption2
    case caption1
    case dialogTitle
}

extension TextStyle {

    private var fontDescription: FontDescription {
        switch self {
        case .display1:
            return FontDescription(font: .semiBold, size: 34, style: .largeTitle)
        case .display2:
            return FontDescription(font: .semiBold, size: 26, style: .title1)
        case .paragraph:
            return FontDescription(font: .regular, size: 17, style: .body)
        case .headline:
            return FontDescription(font: .medium, size: 17, style: .headline)
        case .digitButtonTitle:
            return FontDescription(font: .regular, size: 37, style: .largeTitle)
        case .caption4:
            return FontDescription(font: .regular, size: 10, style: .caption2)
        case .caption3:
            return FontDescription(font: .regular, size: 13, style: .caption2)
        case .caption2:
            return FontDescription(font: .regular, size: 15, style: .caption1)
        case .caption1:
            return FontDescription(font: .medium, size: 15, style: .caption1)
        case .dialogTitle:
            return FontDescription(font: .semiBold, size: 17, style: .headline)
        }
    }

    var font: UIFont {
        guard let font = UIFont(name: fontDescription.font.name, size: fontDescription.size) else {
            return UIFont.preferredFont(forTextStyle: fontDescription.style)
        }

        let fontMetrics = UIFontMetrics(forTextStyle: fontDescription.style)
        return fontMetrics.scaledFont(for: font)
    }

}
