//
//  ObjectsAssembly.swift
//  myprotection
//
//  Created by Rubeg NPO on 19.11.2021.
//  Copyright © 2021 Rubeg NPO. All rights reserved.
//

import Foundation
import Swinject

class FacilitiesAssembly: Assembly {

    func assemble(container: Container) {
        container.register(FacilitiesInteractor.self) { resolver in
            let userDefaultsHelper = resolver.resolve(UserDefaultsHelper.self)!
            let guardServicesApi = resolver.resolve(GuardServicesApi.self)!
            let facilitiesApi = resolver.resolve(FacilitiesApi.self)!

            return FacilitiesInteractor(
                userDefaultsHelper: userDefaultsHelper,
                guardServicesApi: guardServicesApi,
                facilitiesApi: facilitiesApi
            )
        }

        container.register(FacilitiesPresenter.self) { resolver in
            let interactor = resolver.resolve(FacilitiesInteractor.self)!
            let communicationData = resolver.resolve(CommunicationData.self)!
            return FacilitiesPresenterImpl(interactor: interactor, communicationData: communicationData)
        }
    }

}
