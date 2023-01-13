//
//  Color.swift
//  myprotection
//
//  Created by Rubeg NPO on 03.11.2022.
//  Copyright © 2022 Rubeg NPO. All rights reserved.
//

import Foundation

enum Color: String, CaseIterable {
    // Common
    case backgroundPrimary = "Background Primary"
    case backgroundSurface = "Background Surface"
    case backgroundSurfaceVariant = "Background Surface Variant"
    case accent = "Accent Color"
    case accentPale = "Accent Pale Color"
    case darkAppearanceBorder = "Dark Appearance Border"
    case error = "Error Color"
    case cardBackground = "Card Background"
    case segmentedControlBackground = "Segmented Control Background Color"
    case selectedSegmentBackground = "Selected Segment Background Color"
    case alarmButtonBackground = "Alarm Button Background Color"
    case armButtonBackground = "Arm Button Background Color"
    case tabMenuDelimiter = "Tab Menu Delimiter Color"
    case alertDialogBackground = "Alert Dialog Background Color"

    // PIN-code
    case indicatorColor = "Indicator Color"
    case digitButtonBackground = "Digit Button Background"
    case digitButtonHighlightedBackground = "Digit Button Highlighted Background"
    case backspaceButtonColor = "Backspace Button Color"

    // Text
    case textPrimary = "Text Primary"
    case textSecondary = "Text Secondary"
    case textOnAccent = "On Accent Color"
    case textContrast = "Text Contrast"
}
