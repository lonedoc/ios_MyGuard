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
    private let communicationData: CommunicationData

    init(
        loginApi: LoginApi,
        userDefaultsHelper: UserDefaultsHelper,
        communicationData: CommunicationData
    ) {
        self.loginApi = loginApi
        self.userDefaultsHelper = userDefaultsHelper
        self.communicationData = communicationData
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
        let fcmToken = userDefaultsHelper.getFcmToken()
        userDefaultsHelper.reset()

        if let fcmToken = fcmToken {
            userDefaultsHelper.set(fcmToken: fcmToken)
        }

        communicationData.token = nil
    }

    func getIpAddresses() -> [String] {
        return userDefaultsHelper.getGuardService()?.ip ?? []
    }

    func getToken() -> String? {
        return userDefaultsHelper.getToken()
    }

}
