//
//  PasscodeView.swift
//  myprotection
//
//  Created by Rubeg NPO on 19.11.2021.
//  Copyright © 2021 Rubeg NPO. All rights reserved.
//

import Foundation
import UIKit

protocol PasscodeView: AlertDialog {
    func call(_ url: URL)
    func setBiometryType(_ type: BiometryType)
    func setForgotPasscodeButtonIsHidden(_ hidden: Bool)
    func setAppBarIsHidden(_ hidden: Bool)
    func setHint(text: String)
    func setIndicator(value: Int)
    func openLoginScreen()
    func openPasswordScreen()
    func openMainScreen()
}
