//
//  UIColorExtensions.swift
//  myprotection
//
//  Created by Rubeg NPO on 03.11.2022.
//  Copyright © 2022 Rubeg NPO. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    convenience init(color: Color) {
        self.init(named: color.rawValue)!
    }
}
