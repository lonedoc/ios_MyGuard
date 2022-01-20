//
//  LoginInteractor.swift
//  myprotection
//
//  Created by Rubeg NPO on 15.11.2021.
//  Copyright © 2021 Rubeg NPO. All rights reserved.
//

import Foundation
import RxSwift

class LoginInteractor {

    private let guardServicesApi: GuardServicesApi
    private let userDefaultsHelper: UserDefaultsHelper

    init(guardServicesApi: GuardServicesApi, userDefaultsHelper: UserDefaultsHelper) {
        self.guardServicesApi = guardServicesApi
        self.userDefaultsHelper = userDefaultsHelper
    }

    func getGuardServices() -> Observable<[GuardService]> {
        return guardServicesApi.getGuardServices()
    }

    func getUserGuardService() -> GuardService? {
        return userDefaultsHelper.getGuardService()
    }

    func getUserPhone() -> String? {
        return userDefaultsHelper.getPhone()
    }

    func saveUserGuardService(_ guardService: GuardService) {
        userDefaultsHelper.set(guardService: guardService)
    }

    func saveUserPhone(_ phone: String) {
        userDefaultsHelper.set(phone: phone)
    }

}
