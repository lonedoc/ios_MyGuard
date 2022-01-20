//
//  SensorsPresenter.swift
//  myprotection
//
//  Created by Rubeg NPO on 24.12.2021.
//  Copyright © 2021 Rubeg NPO. All rights reserved.
//

import Foundation

protocol SensorsPresenter {
    func attach(view: SensorsView)
    func refresh()
    func viewDidLoad()
    func viewWillAppear()
    func viewWillDisappear()
    func viewWentBackground()
    func viewWentForeground()
}
