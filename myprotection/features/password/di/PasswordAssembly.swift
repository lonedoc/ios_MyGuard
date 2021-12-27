//
//  PasswordAssembly.swift
//  myprotection
//
//  Created by Rubeg NPO on 19.11.2021.
//  Copyright © 2021 Rubeg NPO. All rights reserved.
//

import Foundation
import Swinject

class PasswordAssembly: Assembly {

    func assemble(container: Container) {
        container.register(PasswordApi.self) { resolver in
            let communicationData = resolver.resolve(CommunicationData.self)!
            return UdpPasswordApi(communicationData: communicationData)
        }

        container.register(PasswordInteractor.self) { resolver in
            let passwordApi = resolver.resolve(PasswordApi.self)!
            let loginApi = resolver.resolve(LoginApi.self)!
            let userDefaultsHelper = resolver.resolve(UserDefaultsHelper.self)!

            return PasswordInteractor(
                passwordApi: passwordApi,
                loginApi: loginApi,
                userDefaultsHelper: userDefaultsHelper
            )
        }

        container.register(PasswordPresenter.self) { resolver in
            let interactor = resolver.resolve(PasswordInteractor.self)!
            return PasswordPresenterImpl(interactor: interactor)
        }
    }

}
