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

    func didSelectAccount(account: Account) {
        self.account = account

        view?.setAccount(account)

        if let monthlyPayment = account.monthlyPayment {
            self.sum = monthlyPayment
            view?.setSum(String(monthlyPayment))
        }

        view?.setSubmitButtonEnabled(isUserInputValid())
    }

    func didChangeSum(sum: String) {
        self.sum = Double(sum) ?? self.sum
        view?.setSubmitButtonEnabled(isUserInputValid())
    }

    func didPushSubmitButton() {
        guard
            let accountId = account?.id,
            let paymentSystemUrl = account?.paymentSystemUrl
        else {
            return
        }

        view?.showPaymentPage(accountId: accountId, sum: sum, paymentSystemUrl: paymentSystemUrl)
    }

}

class AccountPresenterImpl {

    private var view: AccountView?

    private var account: Account?
    private var sum: Double = 0.0

    private func isUserInputValid() -> Bool {
        return account != nil && sum > 0.0
    }

}
