//
//  UIImageExtensions.swift
//  myprotection
//
//  Created by Rubeg NPO on 08.11.2022.
//  Copyright © 2022 Rubeg NPO. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    convenience init(image: Image) {
        self.init(named: image.rawValue)!
    }
}
