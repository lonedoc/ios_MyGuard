//
//  PasswordContract.swift
//  myprotection
//
//  Created by Rubeg NPO on 27.07.2020.
//  Copyright © 2020 Rubeg NPO. All rights reserved.
//

import UIKit
import Foundation
import LocalAuthentication

protocol IPasscodeView: UIViewController, AlertDialog {
    func call(to url: URL)
    func setBiometryType(_ type: BiometryType)
    func setForgotPasscodeButtonIsHidden(_ hidden: Bool)
    func setHint(text: String)
    func setIndicator(value: Int)
    func openLoginScreen()
    func openPasswordScreen()
    func openMainScreen(communicationData: CommunicationData)
}

protocol IPasscodePresenter {
    func attach(view: PasscodeContract.View)
    func viewDidLoad()
    func viewDidAppear()
    func phoneButtonTapped()
    func exitButtonTapped()
    func biometricButtonTapped()
    func backspaceButtonTapped()
    func digitButtonTapped(digit: Int)
    func forgotPasscodeButtonTapped()
}

enum PasscodeContract {
    typealias View = IPasscodeView
    typealias Presenter = IPasscodePresenter
}
