//
//  PasscodeAssembly.swift
//  myprotection
//
//  Created by Rubeg NPO on 18.11.2021.
//  Copyright © 2021 Rubeg NPO. All rights reserved.
//

import Foundation
import Swinject

class PasscodeAssembly: Assembly {

    func assemble(container: Container) {
        container.register(BiometryHelper.self) { _ in BiometryHelperImpl() }

        container.register(PasscodeInteractor.self) { resolver in
            let loginApi = resolver.resolve(LoginApi.self)!
            let userDefaultsHelper = resolver.resolve(UserDefaultsHelper.self)!
            let communicationData = resolver.resolve(CommunicationData.self)!

            return PasscodeInteractor(
                loginApi: loginApi,
                userDefaultsHelper: userDefaultsHelper,
                communicationData: communicationData
            )
        }

        container.register(PasscodePresenter.self) { resolver in
            let interactor = resolver.resolve(PasscodeInteractor.self)!
            let biometryHelper = resolver.resolve(BiometryHelper.self)!
            let communicationData = resolver.resolve(CommunicationData.self)!

            return PasscodePresenterImpl(
                interactor: interactor,
                biometryHelper: biometryHelper,
                communicationData: communicationData
            )
        }
    }

}
