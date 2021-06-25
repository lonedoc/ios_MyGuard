//
//  NavigationController.swift
//  myprotection
//
//  Created by Rubeg NPO on 27.07.2020.
//  Copyright © 2020 Rubeg NPO. All rights reserved.
//

import UIKit

class NavigationController: UINavigationController {

    override func viewDidLoad() {
        navigationBar.backgroundColor = .darkBackgroundColor
        navigationBar.barTintColor = .darkBackgroundColor
        navigationBar.isTranslucent = false
        navigationBar.tintColor = .white
        navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]

        modalPresentationStyle = .fullScreen
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) {
            return .lightContent
        }
        return .default
    }

}
