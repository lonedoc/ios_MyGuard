//
//  ApplicationsPresenter.swift
//  myprotection
//
//  Created by Rubeg NPO on 16.05.2022.
//  Copyright © 2022 Rubeg NPO. All rights reserved.
//

import Foundation

protocol ApplicationsPresenter {
    func attach(view: ApplicationsView)
    func viewDidLoad()
    func didSelect(application: String)
    func didChangeApplicationText(applicationText: String)
    func didSelect(dateTime: Date)
    func didPushSubmitButton()
}
