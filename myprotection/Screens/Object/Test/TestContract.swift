//
//  TestContract.swift
//  myprotection
//
//  Created by Rubeg NPO on 25.05.2021.
//  Copyright © 2021 Rubeg NPO. All rights reserved.
//

import UIKit

protocol ITestView: UIViewController, AlertDialog {
    static var willAppear: Notification.Name { get }
    static var willDisappear: Notification.Name { get }
    func setTip(text: String)
    func setCountdown(text: String)
    func setResetButtonEnabled(_ enabled: Bool)
    func close()
}

protocol ITestPresenter {
    func attach(view: TestContract.View)
    func viewDidLoad()
    func applicationWillResignActive()
    func resetButtonPressed()
    func completeButtonPressed()
}

enum TestContract {
    typealias View = ITestView
    typealias Presenter = ITestPresenter
}
