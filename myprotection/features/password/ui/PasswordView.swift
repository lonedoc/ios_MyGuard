//
//  PasswordView.swift
//  myprotection
//
//  Created by Rubeg NPO on 19.11.2021.
//  Copyright © 2021 Rubeg NPO. All rights reserved.
//

import Foundation
import UIKit

protocol PasswordView: AlertDialog {
    func updateTimer(text: String)
    func showRetryButton()
    func showCountDown()
    func hideRetryButton()
    func setProceedButtonEnabled(_ enabled: Bool)
    func openLoginScreen()
    func openPasscodeScreen()
}
