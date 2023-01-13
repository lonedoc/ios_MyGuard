//
//  LoginPresenter.swift
//  myprotection
//
//  Created by Rubeg NPO on 19.11.2021.
//  Copyright © 2021 Rubeg NPO. All rights reserved.
//

import Foundation

protocol LoginPresenter {
    func attach(view: LoginView)
    func viewDidLoad()
    func citySelected(_ city: String)
    func guardServiceSelected(_ guardService: String)
    func phoneNumberChanged(_ value: String)
    func submitButtonTapped()
}
