//
//  AccountView.swift
//  myprotection
//
//  Created by Rubeg NPO on 11.01.2022.
//  Copyright © 2022 Rubeg NPO. All rights reserved.
//

import UIKit

protocol AccountView: AlertDialog {
    func setAccount(_ account: Account)
    func setSum(_ sum: String)
    func setSubmitButtonEnabled(_ enabled: Bool)
    func showPaymentPage(accountId: String, sum: Double, paymentSystemUrl: String)
}
