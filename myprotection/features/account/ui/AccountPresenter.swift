//
//  AccountPresenter.swift
//  myprotection
//
//  Created by Rubeg NPO on 11.01.2022.
//  Copyright © 2022 Rubeg NPO. All rights reserved.
//

import Foundation

protocol AccountPresenter {
    func attach(view: AccountView)
    func didSelectAccount(account: Account)
    func didChangeSum(sum: String)
    func didPushSubmitButton()
}
