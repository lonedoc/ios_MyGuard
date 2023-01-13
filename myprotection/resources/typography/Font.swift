//
//  Font.swift
//  myprotection
//
//  Created by Rubeg NPO on 03.11.2022.
//  Copyright © 2022 Rubeg NPO. All rights reserved.
//

import Foundation

enum Font: String {
    case regular = "Inter-Regular"
    case medium = "Inter-Medium"
    case semiBold = "Inter-SemiBold"
    case bold = "Inter-Bold"

    var name: String {
        return self.rawValue
    }
}
