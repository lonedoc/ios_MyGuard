//
//  ApplicationsView.swift
//  myprotection
//
//  Created by Rubeg NPO on 16.05.2022.
//  Copyright © 2022 Rubeg NPO. All rights reserved.
//

import Foundation
import UIKit

protocol ApplicationsView: AlertDialog {
    func setApplications(_ applications: [String])
    func setSelectedApplication(_ application: String)
    func setApplicationText(_ applicationText: String)
    func setIsApplicationTextFieldEnabled(_ enabled: Bool)
    func setDateTimeText(_ text: String)
    func setIsSubmitButtonEnabled(_ enabled: Bool)
    func goBack()
}
