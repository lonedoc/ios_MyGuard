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
        container.register(GuardServicesApi.self) { _ in UdpGuardServicesApi() }

        container.register(LoginInteractor.self) { resolver in
            let guardServicesApi = resolver.resolve(GuardServicesApi.self)!
            let userDefaultsHelper = resolver.resolve(UserDefaultsHelper.self)!

            return LoginInteractor(
                guardServicesApi: guardServicesApi,
                userDefaultsHelper: userDefaultsHelper
            )
        }

        container.register(LoginPresenter.self) { resolver in
            let interactor = resolver.resolve(LoginInteractor.self)!
            return LoginPresenterImpl(interactor: interactor)
        }
    }

}
