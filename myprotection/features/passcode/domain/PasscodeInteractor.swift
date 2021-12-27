//
//  PasscodeInteractor.swift
//  myprotection
//
//  Created by Rubeg NPO on 29.11.2021.
//  Copyright © 2021 Rubeg NPO. All rights reserved.
//

import Foundation
import RxSwift

class PasscodeInteractor {

    private let loginApi: LoginApi
    private let userDefaultsHelper: UserDefaultsHelper

    init(
        loginApi: LoginApi,
        userDefaultsHelper: UserDefaultsHelper
    ) {
        self.loginApi = loginApi
        self.userDefaultsHelper = userDefaultsHelper
    }

    func logOut() -> Observable<Bool> {
        return loginApi.logOut()
    }

    func getGuardService() -> GuardService? {
        return userDefaultsHelper.getGuardService()
    }

    func isUserLoggedIn() -> Bool {
        return userDefaultsHelper.getToken() != nil
    }

    func getPasscode() -> String? {
        return userDefaultsHelper.getPasscode()
    }

    func setPasscode(_ passcode: String) {
        userDefaultsHelper.set(passcode: passcode)
    }

    func resetPasscode() {
        userDefaultsHelper.reset(key: .passcode)
    }

    func resetUserData() {
        userDefaultsHelper.reset()
    }

    func getIpAddresses() -> [String] {
        return userDefaultsHelper.getCompany()?.ip ?? []
    }

    func getToken() -> String? {
        return userDefaultsHelper.getToken()
    }

}
