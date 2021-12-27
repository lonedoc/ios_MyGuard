//
//  PasswordPresenter.swift
//  myprotection
//
//  Created by Rubeg NPO on 19.11.2021.
//  Copyright © 2021 Rubeg NPO. All rights reserved.
//

import Foundation

protocol PasswordPresenter {
    func attach(view: PasswordView)
    func viewDidLoad()
    func didHitRetryButton()
    func didHitProceedButton()
    func didChangePassword(value: String)
    func didHitCancelButton()
}
