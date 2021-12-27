//
//  LoginView.swift
//  myprotection
//
//  Created by Rubeg NPO on 19.11.2021.
//  Copyright © 2021 Rubeg NPO. All rights reserved.
//

import Foundation
import UIKit

protocol LoginView: UIViewController, AlertDialog {
    func setCities(_ cities: [String])
    func setCompanies(_ companies: [String])
    func selectCityPickerRow(_ row: Int)
    func selectCompanyPickerRow(_ row: Int)
    func setCity(_ value: String)
    func setCompany(_ value: String)
    func setPhoneNumber(_ value: String)
    func setSubmitButtonEnabled(_ enabled: Bool)
    func openPasswordScreen()
}
