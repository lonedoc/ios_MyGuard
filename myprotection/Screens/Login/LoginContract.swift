//
//  LoginContract.swift
//  alarmbutton
//
//  Created by Rubeg NPO on 12/06/2020.
//  Copyright © 2020 Rubeg NPO. All rights reserved.
//

import UIKit
import Foundation

protocol ILoginView: UIViewController, AlertDialog {
    func setCities(_ cities: [String])
    func setCompanies(_ companies: [String])
    func selectCityPickerRow(_ row: Int)
    func selectCompanyPickerRow(_ row: Int)
    func setCity(_ value: String)
    func setCompany(_ value: String)
    func setPhoneNumber(_ value: String)
    func setSubmitButtonEnabled(_ enabled: Bool)
    func openPasswordScreen(ip: [String], phone: String)
}

protocol ILoginPresenter {
    func attach(view: LoginContract.View)
    func viewDidLoad()
    func didSelect(city: String)
    func didSelect(company: String)
    func didChangePhone(value: String)
    func didHitSubmitButton()
    func didHitRetryButton()
}

enum LoginContract {
    typealias View = ILoginView
    typealias Presenter = ILoginPresenter
}
