//
//  LoginAssembly.swift
//  myprotection
//
//  Created by Rubeg NPO on 18.11.2021.
//  Copyright © 2021 Rubeg NPO. All rights reserved.
//

import Foundation
import Swinject

class LoginAssembly: Assembly {

    func assemble(container: Container) {
        container.register(CompaniesApi.self) { _ in UdpCompaniesApi() }

        container.register(LoginInteractor.self) { resolver in
            let companiesApi = resolver.resolve(CompaniesApi.self)!
            let userDefaultsHelper = resolver.resolve(UserDefaultsHelper.self)!

            return LoginInteractor(
                companiesApi: companiesApi,
                userDefaultsHelper: userDefaultsHelper
            )
        }

        container.register(LoginPresenter.self) { resolver in
            let interactor = resolver.resolve(LoginInteractor.self)!
            return LoginPresenterImpl(interactor: interactor)
        }
    }

}
