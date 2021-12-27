//
//  PasswordContract.swift
//  myprotection
//
//  Created by Rubeg NPO on 27.07.2020.
//  Copyright © 2020 Rubeg NPO. All rights reserved.
//

import Foundation

protocol PasscodePresenter {
    func attach(view: PasscodeView)
    func viewDidLoad()
    func viewDidAppear()
    func phoneButtonTapped()
    func exitButtonTapped()
    func biometricButtonTapped()
    func backspaceButtonTapped()
    func digitButtonTapped(digit: Int)
    func forgotPasscodeButtonTapped()
}
