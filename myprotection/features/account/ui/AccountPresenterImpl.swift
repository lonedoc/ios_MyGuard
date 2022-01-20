//
//  AccountPresenterImpl.swift
//  myprotection
//
//  Created by Rubeg NPO on 13.01.2022.
//  Copyright © 2022 Rubeg NPO. All rights reserved.
//

import Foundation

extension AccountPresenterImpl: AccountPresenter {

    func attach(view: AccountView) {
        self.view = view
    }

    func didChangeAccountId(accountId: String) {
        self.accountId = accountId
        view?.setSubmitButtonEnabled(isUserInputValid())
    }

    func didChangeSum(sum: String) {
        self.sum = Double(sum) ?? self.sum
        view?.setSubmitButtonEnabled(isUserInputValid())
    }

}

class AccountPresenterImpl {

    private var view: AccountView?

    private var accountId: String = ""
    private var sum: Double = 0.0

    private func isUserInputValid() -> Bool {
        return !accountId.isEmpty && sum > 0.0
    }

}
