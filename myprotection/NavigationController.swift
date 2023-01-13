//
//  NavigationController.swift
//  myprotection
//
//  Created by Rubeg NPO on 27.07.2020.
//  Copyright © 2020 Rubeg NPO. All rights reserved.
//

import Foundation
import UIKit

class NavigationController: UINavigationController {

    override func viewDidLoad() {
        navigationBar.backgroundColor = UIColor(color: .cardBackground)
        navigationBar.barTintColor = UIColor(color: .cardBackground)
        navigationBar.isTranslucent = false
        modalPresentationStyle = .overFullScreen
    }

}
