//
//  LoginView.swift
//  myprotection
//
//  Created by Rubeg NPO on 19.11.2021.
//  Copyright © 2021 Rubeg NPO. All rights reserved.
//

import Foundation
import UIKit

protocol LoginView: AlertDialog {
    func setCities(_ cities: [String])
    func setGuardServices(_ guardServices: [String])
    func selectCityPickerRow(_ row: Int)
    func selectGuardServicePickerRow(_ row: Int)
    func setCity(_ value: String)
    func setGuardService(_ value: String)
    func setPhoneNumber(_ value: String)
    func setSubmitButtonEnabled(_ enabled: Bool)
    func openPasswordScreen()
}
