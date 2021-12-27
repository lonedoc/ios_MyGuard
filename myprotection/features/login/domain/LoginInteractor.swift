//
//  LoginInteractor.swift
//  myprotection
//
//  Created by Rubeg NPO on 15.11.2021.
//  Copyright © 2021 Rubeg NPO. All rights reserved.
//

import Foundation

class LoginInteractor {

    private let companiesApi: CompaniesApi
    private let userDefaultsHelper: UserDefaultsHelper

    init(companiesApi: CompaniesApi, userDefaultsHelper: UserDefaultsHelper) {
        self.companiesApi = companiesApi
        self.userDefaultsHelper = userDefaultsHelper
    }

    func getCompanies(
        success: @escaping ([Company]) -> Void,
        failure: @escaping (Error) -> Void
    ) {
        companiesApi.getCompanies(
            success: success,
            failure: failure
        )
    }

    func getUserCompany() -> Company? {
        return userDefaultsHelper.getCompany()
    }

    func getUserPhone() -> String? {
        return userDefaultsHelper.getPhone()
    }

    func saveUserCompany(_ company: Company) {
        userDefaultsHelper.set(company: company)
    }

    func saveUserPhone(_ phone: String) {
        userDefaultsHelper.set(phone: phone)
    }

}
