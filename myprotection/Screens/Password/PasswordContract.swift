//
//  PasswordContract.swift
//  alarmbutton
//
//  Created by Rubeg NPO on 22/06/2020.
//  Copyright © 2020 Rubeg NPO. All rights reserved.
//

import UIKit
import Foundation

protocol IPasswordView: UIViewController, AlertDialog {
    func updateTimer(text: String)
    func showRetryButton()
    func showCountDown()
    func hideRetryButton()
    func setProceedButtonEnabled(_ enabled: Bool)
//    func showRetryDialog(code: Int)
//    func openMainScreen(phone: String, password: String, ipAddresses: [String], currentIpIndex: Int)
    func openLoginScreen()
    func openPasscodeScreen()
}

protocol IPasswordPresenter {
    func attach(view: PasswordContract.View)
    func viewDidLoad()
    func didHitRetryButton()
    func didHitProceedButton()
//    func viewWillAppear()
//    func viewWillDisappear()
    func didChangePassword(value: String)
//    func didHitRetryButton(code: Int)
//    func didHitProceedButton()
    func didHitCancelButton()
}

enum PasswordContract {
    typealias View = IPasswordView
    typealias Presenter = IPasswordPresenter
}
