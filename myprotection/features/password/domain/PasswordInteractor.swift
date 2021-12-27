//
//  PasswordInteractor.swift
//  myprotection
//
//  Created by Rubeg NPO on 25.11.2021.
//  Copyright © 2021 Rubeg NPO. All rights reserved.
//

import Foundation
import RxSwift

class PasswordInteractor {

    private let passwordApi: PasswordApi
    private let loginApi: LoginApi
    private let userDefaultsHelper: UserDefaultsHelper

    init(
        passwordApi: PasswordApi,
        loginApi: LoginApi,
        userDefaultsHelper: UserDefaultsHelper
    ) {
        self.passwordApi = passwordApi
        self.loginApi = loginApi
        self.userDefaultsHelper = userDefaultsHelper
    }

    func resetPassword(phone: String) -> Observable<Bool> {
        return passwordApi.resetPassword(phone: phone)
    }

    func logIn(
        credentials: Credentials,
        fcmToken: String,
        device: String
    ) -> Observable<LoginResponse> {
        return loginApi.logIn(
            credentials: credentials,
            fcmToken: fcmToken,
            device: device
        )
    }

    func logOut() -> Observable<Bool> {
        return loginApi.logOut()
    }

    func getUserPhone() -> String? {
        return userDefaultsHelper.getPhone()
    }

    func getFcmToken() -> String? {
        return userDefaultsHelper.getFcmToken()
    }

    func saveUser(_ user: User) {
        userDefaultsHelper.set(user: user)
    }

    func saveGuardService(_ guardService: GuardService) {
        userDefaultsHelper.set(guardService: guardService)
    }

    func saveToken(_ token: String) {
        userDefaultsHelper.set(token: token)
    }

}
