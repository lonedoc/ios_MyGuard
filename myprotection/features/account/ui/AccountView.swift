//
//  AccountView.swift
//  myprotection
//
//  Created by Rubeg NPO on 11.01.2022.
//  Copyright © 2022 Rubeg NPO. All rights reserved.
//

import UIKit

protocol AccountView: UIViewController, AlertDialog {
    func setSubmitButtonEnabled(_ enabled: Bool)
}
