//
//  TestContract.swift
//  myprotection
//
//  Created by Rubeg NPO on 25.05.2021.
//  Copyright © 2021 Rubeg NPO. All rights reserved.
//

import UIKit

protocol TestPresenter {
    func attach(view: TestView)
    func viewDidLoad()
    func applicationWillResignActive()
    func resetButtonPressed()
    func completeButtonPressed()
}
