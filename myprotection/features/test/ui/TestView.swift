//
//  TestView.swift
//  myprotection
//
//  Created by Rubeg NPO on 22.11.2021.
//  Copyright © 2021 Rubeg NPO. All rights reserved.
//

import Foundation
import UIKit

protocol TestView: UIViewController, AlertDialog {
    static var willAppear: Notification.Name { get }
    static var willDisappear: Notification.Name { get }
    func setTip(text: String)
    func setCountdown(text: String)
    func setResetButtonEnabled(_ enabled: Bool)
    func close()
}
